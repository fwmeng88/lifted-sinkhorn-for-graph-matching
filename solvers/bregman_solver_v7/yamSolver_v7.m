function [X,X_proj,Y,iter,run_time,ERR,ERRp ] = yamSolver_v7( params)
%PC1C2_SOFTMAX Summary of this function goes here
%   Detailed explanation goes here

W = params.W;
stop_critiria = params.stop_critiria;
type = params.type;
max_iterations = params.max_iterations;
params_proj.entropy = params.entropy;
n = size(W,1);
params_proj.n = size(W,1); 
d = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
Winf = W;%initielize W at DS++ zeros position to be inf (so exp(-W./ent) = 0 at this points)
[idx1 ,idx2 ,idx3 ,idx4]=ndgrid(1:n,1:n,1:n,1:n);
% Winf(idx1 == idx3 & idx2 ~= idx4) = inf;%ds ++ zeros enforcing 
% Winf(idx1 ~= idx3 & idx2 == idx4) = inf;%%ds ++ zeros enforcing 
h = waitbar(0,'nuber of iterations is ...');
[u1,v1] = y_projection_v7_first(Winf,ones(n),d,1,10,params_proj);
params_proj.entropy = 1;
for i = 2:max_iterations
    waitbar(i / max_iterations,h,i);
    u1_temp = u1;
    switch type
        case 'p4'
            [u2,v2] = y_projection_v7(v1,u1,d,2,10,params_proj);
            [u3,v3] = y_projection_v7(v2,u2,d,3,10,params_proj);
            [u4,v4] = y_projection_v7(v3,u3,d,4,10,params_proj);
            [u1,v1] = y_projection_v7(v4,u4,d,1,10,params_proj);
        case 'sym'
            [u2,v2] = y_projection_v7(v1,u1,d,2,10,params_proj);
            [u1,v1] = y_projection_v7(v2,u2,d,1,10,params_proj);
            v1 = sym_projection(v1);
    end
    if stopping_criteria(u1_temp,u1,stop_critiria) 
        break; end
end
run_time = toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iter = i;
if iter == max_iterations
    warning('warning, max iterations alowed was riched');
end
close(h) 
X = u1;
Y = v1;
ERR= sum(Y(:).*W(:));

%% projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(1)
try
    a = abs(randn(n))*min(X(:))./10000;
    X_next = linearAssignmentSolver(-(X + a));
    for i = 1:4
        a = abs(randn(n))*min(X_next(:))./10000;
        X_proj = linearAssignmentSolver(-(X_next + a));
    end
catch 
    X_proj = 0;
end
ERRp = X_proj(:)'*reshape(W,[n^2,n^2])*X_proj(:);
end

