function [X_proj_new,Efinal] = frankWolfeSolver2(A,B,params)
%% locally minimiz tr(AXBX^T) s.t. X \in DS

tic
params.null = [];
numIters = getoptions(params,'numIters',100);
threshold = getoptions(params,'threshold',10^-6);
Xinit = getoptions(params,'Xinit',eye(size(A,1)));
% translation = getoptions(params,'translation',0);
step = getoptions(params,'step',0);
maxsteps = getoptions(params,'maxsteps',10);

% % my aditions (Yam)
n = size(A,1);
%%%%%%%%%%%%%%%%%%%%%


% start iterations
cX = Xinit;
tX = {};
diff = inf;
iter = 1;
E = [];
while (iter <=  numIters) && (diff > threshold)
    step_energy = [];

    cnt=1;
    for translation = step
        
        % calc gradient d/dX (tr(AXBX^T)-optTranslation*||X||^2)=2AXB
        C = 2*A*cX*B-2*(translation)*cX;
        % flip sign since the solver maximizes
        C=-C;
        % add minimum so all is positive for solver
        C = C-min(C(:));
        % solve linear assignmnet
        scalingFactor = 10^1;
        Cscaled = C*scalingFactor;
        [~, tX{cnt}] = ...
            sparseAssignmentProblemAuctionAlgorithm(Cscaled);
        step_energy = [step_energy trace(A*tX{end}*B*tX{end}')];
        
        cnt=cnt+1;
    end
    
    [dval, ti] = min(step_energy);
    cX = tX{ti};
    E(iter) = dval;
    iter = iter+1;
end

figure,plot(E)
fprintf('Frank-Wolfe solver: Optimization has finished. iter = %d, diff = %.6f \n',iter,full(diff))

X_proj_new = cX;
Efinal = E(end);
toc
end