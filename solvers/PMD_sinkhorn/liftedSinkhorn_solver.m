function [ O_params] = liftedSinkhorn_solver( expZ,expW,params )
%LIFTEDSINKHORN_SOLVER approximates the solution of the linear program:
%
% This code solves an LP relaxation to the combinatorial QAP problem:
%   min_X [X]^T W [X} + tr(XZ')
%   s.t.   X is a permutation
%
% That is,
%   min_{X,Y} tr(YW')+tr(XZ')
%   s.t.      
%           sum_i (Xij) = 1
%           sum_j (Xij) = 1
%           sum_i(Y_ijkl) = X_kl   
%           sum_j(Y_ijkl) = X_kl   
%           sum_k(Y_ijkl) = X_ij   
%           sum_l(Y_ijkl) = X_ij   
%           Y_ijkl = 0    for i=k, j~=l
%           Y_ijkl = 0    for j=l, i~=k
%           Y_ijkl , X_ij >= 0
%
% by solving the regularized problem: 
%   min_{X,Y} KL(X|exp(-Z/alpha)) + KL(Y|exp(-W/alpha))
%   s.t.      
%           sum_i (Xij) = 1
%           sum_j (Xij) = 1
%           sum_i(Y_ijkl) = X_kl   
%           sum_j(Y_ijkl) = X_kl   
%           sum_k(Y_ijkl) = X_ij   7
%           sum_l(Y_ijkl) = X_ij   
%           Y_ijkl = 0    for i=k, j~=l
%           Y_ijkl = 0    for j=l, i~=k
%
% using Bregman iterations.
%
% This code also support a one sided version of the QAP problem:
%   min_X [X]^T W [X] + tr(XZ')
%   s.t.   X is a labeling matrix (each row has exactly single one) 
%--------------------------------------------------------------------------
%INPUT
%   params - struct 
%           max_iterations - int, maximal number of iterations 
%           entropy - double, enrtopy wight in the energy term 
%           stop_critiria, stopping cratiria for the algorithm distance in infinitiy norm between (Xn - Xn+1) ). regular term 10^-4;
%           Z - matrix n x m, enrgy argument of the unary term
%           W - matrix n^2 x n^2, enrgy argument of the binary term (not neseccerly exists)
%           A - matrix n x n, distnce matrix of graph A (only of permutation estimation problems)
%           B - matrix n x n, distnce matrix of graph B (only of permutation estimation problems)
%           type - str, 'permutation'  for estimating permutation matrix
%                       'labelling' for estimating an assignment matrix
%           sparse - bool, true if we have a sparse adj matrix folse otherwise
%           adj - matrix n x n, the adjacancy matrix of the graph
%           n - int, the first dimansion of the estimated matrix
%           m - int, the second dimansion of the estimated matrix
%--------------------------------------------------------------------------
%OUTPUT
%   O_params - struct
%            X - matrix n x n, solution to the relaxed problem
%            Y - matrix n^2 x n^2 solution to the relaxed problem Y
%            X_projected - matrix n x m, estimated permuation 
%            no_iterations - int, nuber of iteration lifted_sinkhorn took to converge
%            run_time - double, time it took algorithm to converge  
%            energy_LB - double, energy of the given solution X,Y (of the
%                       relaxed problem)    
%            energy_UB - double, energy of the estimated permutation of the
%                       original ptoblem 
%% --------------------------------------------------------------------------
max_iterations = params.max_iterations;                                  %maximal number of bregman iterations
stop_critiria = params.stop_critiria_sinkhorn; 
doDisplay=getoptions(params,'graphics',true);
%stopping condition criteria
%% --------------------------------------------------------------------------
% Bregman iterations
if ~params.sparse
    [ Y,X ] = KL_projection_fast( expW,expZ,2);                               %projection 2
elseif params.sparse
    KLP_params.adjW = kron(ones(params.m),params.Adj);                   %W indicator matrix
    KLP_params.Adj_norm1 = ones(params.m,1)*sum(params.Adj,1);           %row sum of adjacency matrix
    KLP_params.Adj_norm2 = sum(params.Adj,2)*ones(1,params.m);           %columb sum of adjacency matrix
    KLP_params.v_Wadj = params.v_Wadj;                                   %linear indexing of W indicator matrix
    [ Y,X ] = KL_projection_sparse( expW,expZ,2,KLP_params);             %sparse projection 2
end
for iter = 1:max_iterations
    switch params.type
        case 'permutation'                                           %solving the permutation constraints - 4 iterations on 4 diferante spaces
            [ Y,X,~] = KL_projection_fast( Y,X,3);                        %projection 3     
            [ Y,X,~] = KL_projection_fast( Y,X,4);                        %projection 4
            [ Y,X_prev,~  ] = KL_projection_fast( Y,X,1);                 %projection 1 + load in to X_prev this projection 
            [ Y,X,break_flag] = KL_projection_fast( Y,X_prev,2);          %projection 2
        case 'labelling'                                             %solving the asignmant constraint - 2 iterations on deferante spaces
        if ~params.sparse                                            %solve using dence matrices (regular)
            [ Y,X_prev,~] = KL_projection( Y,X,4);                   %projection 4 + load in to X_prev this projection
            [ Y,X,break_flag] = KL_projection( Y,X_prev,2);          %projection 2 
        elseif params.sparse                                         %solve using sparse matrices     
            [ Y,X_prev,~] = KL_projection_sparse( Y,X,4,KLP_params); %projection 4 + load in to X_prev this projection
            [ Y,X,break_flag] = KL_projection_sparse( Y,X_prev,2,KLP_params); %projection 2
        end
    end
    %BREAKING CONDITION 
    [fisbl_dist(iter),fisbl_stop_flag] = stopping_criteria(X,Y,stop_critiria);
    %%%%%%%%%%%%%
    if doDisplay
    figure(5);
    plot(fisbl_dist); hold on
    plot(ones(iter,1)*stop_critiria); hold off
    title('convergence to stop critiria - internal iterations')
    pause(0.001);
    end
    %%%%%%%%%%%%%
   
    
  
    if fisbl_stop_flag || break_flag           %norm infinity < stop critiria stopping condition 
        break; end

end
if params.sparse
    energy = sum(sum(Y.*params.W)) + sum(X(:).*params.Z(:));             %calculate energy for X,Y(relaxed ptoblem)
else
    energy = sum(Y(:).*params.W(:)) + sum(X(:).*params.Z(:));            %calculate energy for X,Y SPARSE(relaxed ptoblem)
end
%% --------------------------------------------------------------------------
%output parameters
O_params.iterations_flag = false;
if iter == max_iterations                                            %iteration stoping condition (conferm if max iteration was reeched 
    O_params.iterations_flag = true;
end
O_params.X = X;                                         %solution to the relaxed problem X
O_params.Y = Y;                                         %solution to the relaxed problem Y
O_params.no_iterations = iter;                          %number of iteration it took to converge
O_params.energy = energy;                               %optimal solution LB (achived by solving the relaxed problem)
O_params.break_flag = break_flag;
end