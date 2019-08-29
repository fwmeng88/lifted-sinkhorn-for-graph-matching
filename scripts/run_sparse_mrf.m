%---------------------------------------------------------------
%script_simple_QAP_example �
%INPUT
% �XXX TODO XXX
%---------------------------------------------------------------
rng(1);
% min  [X]^T W [X]

% s.t.  X is permutation
n = 100;
m = 2;
Ent = 1;
%generate a sparce Adj matrix A
A = zeros(n);
A(1,n) = 1;
A(1,2) = 1;
for i = 2:n-1
    A(i,i+1) = 1;
    A(i,i-1) = 1;
end
A(n,1) = 1; 
A(n,n-1) = 1;
%generate small W
w(1,1) = 4;
w(1,2) = 3;
w(2,1) = 3;
w(2,2) = 1;
%generate big W
W = kron(w,A);

figure(1);imagesc(W);

%---------------------------------------------------------------
% run experiments
%---------------------------------------------------------------
PMD_params.stop_critiria = 10^-3;
PMD_params.stop_critiria_sinkhorn = 10^-4;

% PMD_params.entropy =Ent;% 0.01;
PMD_params.Z = zeros(n,m);
PMD_params.W = W;
PMD_params.type = 'labelling'; %labelling
PMD_params.n = n; %the dimensions of unknown X
PMD_params.m = m; 
PMD_params.entropy = 1;
PMD_params.max_iterations = 1000;
PMD_params.Adj = A;
PMD_params.graphics = true;
PMD_params.sparse = true;
[ O_params ] = PMD_sinkhorn( PMD_params );
%%%

PMD_params.sparse = false;
[ O_params2 ] = PMD_sinkhorn( PMD_params );