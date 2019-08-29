function [X_proj_new,Efinal] = frankWolfeSolver(A,B,params)
%% locally minimiz tr(AXBX^T) s.t. X \in DS
params.null = [];
doDisplay=params.doDisplay;
numIters = getoptions(params,'numIters',100);
threshold = getoptions(params,'threshold',10^-6);
Xinit = getoptions(params,'Xinit',eye(size(A,1)));
translation = getoptions(params,'translation',0);
step = getoptions(params,'step',0);
maxsteps = getoptions(params,'maxsteps',10);

% % my aditions (Yam)
n = size(A,1);
%%%%%%%%%%%%%%%%%%%%%


% start iterations
cX = Xinit;
tX = cX;
diff = inf;
iter = 1;
E = [];
while (iter <=  numIters) && (diff > threshold)
    E(iter) = trace(A*cX*B'*cX');
    additionalTranslation = 0;
    numSteps = 0;
    while trace(A*cX*B'*cX')<=trace(A*tX*B'*tX')
        % calc gradient d/dX (tr(AXBX^T)-optTranslation*||X||^2)=2AXB
        C = 2*A*cX*B-2*(translation+additionalTranslation)*cX;
        % flip sign since the solver maximizes
        C=-C;
        % add minimum so all is positive for solver
        C = C-min(C(:));
        % solve linear assignmnet
        scalingFactor = 10^1;
        Cscaled = C*scalingFactor;
        [~, tX] = ...
            sparseAssignmentProblemAuctionAlgorithm(Cscaled);
        additionalTranslation = additionalTranslation+step;
        numSteps = numSteps+1;
        if numSteps>maxsteps
            break
        end
    end
    % if we exited since steps are not helping use previous nX
    if numSteps<=maxsteps
        % prepare for next iteration
        nX = tX;
        diff = max(abs(nX(:)-cX(:)));
        if doDisplay
        fprintf('norm diff from last iter = %.4f...\n',norm(nX(:)-cX(:)))
        end
        cX = tX;        
        iter = iter+1;
    else
        break
    end
end

if doDisplay
figure,plot(E)
fprintf('Frank-Wolfe solver: Optimization has finished. iter = %d, diff = %.6f \n',iter,full(diff))
end

X_proj_new = cX;
Efinal = E(end);
end