function [ O_params ] = PMD_sinkhorn( PMD_params )
%PMD_SINKHORN approximates the solution of the quadratic program:

%   min_X [X]^T W [X} + tr(XZ')
%   s.t.   X is a permutation
%
% That is, solving the relaxation -
%   min_{X,Y} tr(YW')+tr(XZ')
%   s.t.
%           sum_i (Xij) = 1
%           sum_j (Xij) = 1
%           sum_i(Y_ijkl) = X_kl
%           sum_j(Y_ijkl) = X_kl
%           sum_k(Y_ijkl) = X_ij
%           sum_l(Y_ijkl) = X_ij
%           Y_ijkl = 0    for i=k, j~=l
%           Y_ijkl = 0  `  for j=l, i~=k
%           Y_ijkl , X_ij >= 0
%
% by iterativly solving the regularized problem:
%   min_{X_i+1,Y_i+1} KL(X|exp(-Z/alpha).*Xi) + KL(Y|exp(-W/alpha)*Yi)
%   s.t.
%           sum_i (Xij) = 1
%           sum_j (Xij) = 1
%           sum_i(Y_ijkl) = X_kl
%           sum_j(Y_ijkl) = X_kl
%           sum_k(Y_ijkl) = X_ij
%           sum_l(Y_ijkl) = X_ij
%           Y_ijkl = 0    for i=k, j~=l
%           Y_ijkl = 0    for j=l, i~=k
%
% using PMD
%
% This code also support a one sided version of the QAP problem:
%   min_X [X]^T W [X] + tr(XZ')
%   s.t.   X is a labeling matrix (each row has exactly single one)
%--------------------------------------------------------------------------
%INPUT
%   params - struct
%           max_iterations - int, maximal number of iterations
%           stop_critiria, stopping cratiria for the algorithm distance in infinitiy norm between (Xn - Xn+1) ). regular term 10^-2;
%           Z - matrix n x m, enrgy argument of the unary term
%           W - matrix n^2 x n^2, enrgy argument of the binary term (not neseccerly exists)
%           A - matrix n x n, distnce matrix of graph A (only of permutation estimation problems)
%           B - matrix n x n, distnce matrix of graph B (only of permutation estimation problems)
%           type - str, 'permutation'  for estimating permutation matrix
%                       'labelling' for estimating an assignment matrix
%           sparse - bool, true if we have a sparse adj matrix folse otherwise
%           Adj - matrix n x n, adjacency matrix of graph (sopose to be sparce)
%           n - int, the first dimansion of the estimated matrix
%           m - int, the second dimansion of the estimated matrix
%--------------------------------------------------------------------------
%OUTPUT
%   O_params - struct
%            X - matrix n x n, solution to the relaxed problem
%            Y - matrix n^2 x n^2 solution to the relaxed problem Y
%            no_iterations - int, nuber of iteration lifted_sinkhorn took to converge
%            run_time - double, time it took algorithm to converge
%            energy - double, energy of the X,Y integer solution

%            THE FOLLOING VALUES ARE RETURNED ONLY IF THE ALGORITHEM DIDN'T
%                                       CONVERGE
%            X_projected - matrix n x m, estimated permuation
%            energy_LB - double, energy of the given solution X,Y (of the
%                       relaxed problem) - for
%            energy_UB - double, energy of the estimated permutation of the
%                       original ptoblem
%% --------------------------------------------------------------------------
n = PMD_params.n;
m = PMD_params.m;
max_iterations = PMD_params.max_iterations;
entropy = PMD_params.entropy;

doDisplay=getoptions(PMD_params,'graphics',true);

[ W,Winf,Z ] = preprocces_input( PMD_params); %generate input for the Bregman iterations
%(Winf,Z) and W,Z that define the term we wish to minimize
LS_params = PMD_params;                       %put PMD_params in to the LS_params (Lifted Sinkhorn)
LS_params.W = W;                              %put generated W in the LS_solver parameters
LS_params.entropy = entropy;   %set the entropy for the LS_solver
LS_params.graphics = PMD_params.graphics;
if PMD_params.sparse
    Adj = PMD_params.Adj;
    Wadj =logical(kron(ones(m),Adj));             %boolean indexing matrix of W
    v_Wadj = find(Wadj == 1);
    LS_params.v_Wadj = v_Wadj;                    %linear indexing of the adjacency matrix in W
    expW = zeros(m*n,m*n);
    expW(v_Wadj) = exp(-Winf(v_Wadj)./entropy);       %initielize the KL divergece arguments for Y
    expW = sparse(expW);
else
    expW = exp(-Winf./entropy);
end

expZ = exp(-Z./entropy);                          %initielize the KL divergece arguments for X
expZmulX = expZ;
expWmulY = expW;
X_prev = zeros(PMD_params.n,PMD_params.m);
total_iterations = 0;
%PMD algorithm
if doDisplay
    h = waitbar(0,'Please wait...');
end
tic

for i = 1:max_iterations
    % keep O_params_prev instead of X and Y
    [ O_params] = liftedSinkhorn_solver(expZmulX,expWmulY,LS_params); %a single iteration solver
    expZmulX = expZmulX.*O_params.X;                                  %updata the KL argument for X
    expWmulY = expWmulY.*O_params.Y;                                  %updata the KL argument for Y
    %     expZmulX = expZ.*O_params.X;                                    %updata the KL argument for X
    %     expWmulY = expW.*O_params.Y;                                    %updata the KL argument for Y
    %%%%%% remove if you see this %%%%%%%%%%%
    disp(i)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %stopping condition
    if(O_params.iterations_flag)
        if doDisplay
            warning('max iteration reached.');
        end
        O_params.X = X_prev;
        O_params.Y = Y_prev;
    end
    
    if i>10
        if norm(O_params.energy - energy(i-1))<PMD_params.stop_critiria*abs(energy(i-1))        %norm infinity < stop critiria stopping condition
            %if norm((O_params.X - X_prev),'inf')<PMD_params.stop_critiria        %norm infinity < stop critiria stopping condition
            if doDisplay
                disp('baby');
            end
            break;
        end
        if O_params.break_flag
            if doDisplay
                disp('shbaby');
            end
            break;
        end
    end
    X_prev = O_params.X;
    Y_prev = O_params.Y;
    total_iterations = total_iterations + O_params.no_iterations;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DEBUG %%%%%%
    energy(i) = O_params.energy;
    
    
    %X_prev = O_params.X;
    if PMD_params.graphics
        figure(1); imagesc(O_params.X);
        figure(2); imagesc(reshape(O_params.Y,[n*m,n*m]));
        pause(0.01);
        figure(4);
        plot(energy);
        title('energy - external iterations')
        disp(energy(i));
    end
    if doDisplay
        waitbar(i/max_iterations,h,num2str(i));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%% projection
if strcmp(PMD_params.type,'permutation')
    %naiv projection
    Xp = munkres(-O_params.X);
    Wm = reshape(W,[n*m,n*m]);
    energy_p = Xp(:)'*Wm*Xp(:) + Xp(:)'*Z(:);
    %frank wolfe projection
    try
        params_fw.Xinit  = O_params.X;
        params_fw.doDisplay=doDisplay;
        [Xp_fw,~] = frankWolfeSolver(PMD_params.A,PMD_params.B,params_fw);
        energy_p_fw = Xp_fw(:)'*Wm*Xp_fw(:);
        if energy_p_fw < energy_p
            energy_p = energy_p_fw;
            Xp = Xp_fw;
        end
    catch
        if doDisplay
            warning('frank wolfe projcetion faild to converge');
        end
    end
    O_params.Xp = Xp;
    O_params.energy_p = energy_p;
end
O_params.run_time = toc;
O_params.no_iterations = total_iterations;
O_params.energy_v = energy;
O_params.energy = energy(end);
O_params.A = PMD_params.A;
O_params.B = PMD_params.B;

end