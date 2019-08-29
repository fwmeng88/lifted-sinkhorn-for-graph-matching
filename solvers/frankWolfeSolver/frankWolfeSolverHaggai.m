function [X_proj_new,Efinal] = frankWolfeSolverHaggai(A,B,params)
%% locally minimiz tr(AXBX^T) s.t. X \in DS
params.null = [];
numIters = getoptions(params,'numIters',100);
threshold = getoptions(params,'threshold',10^-6);
Xinit = getoptions(params,'Xinit',eye(size(A,1)));

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
    C = 2*A*cX*B;
    % flip sign since the solver maximizes
    C=-C;
    % add minimum so all is positive for solver
    C = C-min(C(:));
    % solve linear assignmnet
    scalingFactor = 10^1;
    Cscaled = C*scalingFactor;
    [~, tX] = ...
        sparseAssignmentProblemAuctionAlgorithm(Cscaled);
    % prepare for next iteration
    nX = tX;
    diff = max(abs(nX(:)-cX(:)));
    %fprintf('norm diff from last iter = %.4f...\n',norm(nX(:)-cX(:)))
    cX = tX;
    iter = iter+1;
end


%figure,plot(E)
%fprintf('Frank-Wolfe solver: Optimization has finished. iter = %d, diff = %.6f \n',iter,full(diff))

X_proj_new = cX;
Efinal = E(end);
end