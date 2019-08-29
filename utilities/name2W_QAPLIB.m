function [ Params ] = name2W_QAPLIB( file_path,file_path_GT)
%FILENAME2W from a data set name, we generate the W matrix for QAPLIB

%% Data load
%file_path = fullfile('datasetHandling','test_data',file_name);
%file_path_GT = fullfile('datasetHandling','GT',file_name);
[ D1,D2,n,X_GT,err_GT ] = get_QAPLIB_data(file_path,file_path_GT);
assert(size(D1,2) == n,'n and dimensions of distance matrix must agree');

%% generate W %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W = calcWfromDistMats_kronProd(D1,D2,[]);
if X_GT(:)'*W*X_GT(:) ~= err_GT
    W = calcWfromDistMats_kronProd(D2,D1,[]);
    Dtemp = D2;
    D2 = D1;
    D1 = Dtemp;
end
skip_flag = X_GT(:)'*W*X_GT(:) ~= err_GT;
if skip_flag
    disp(file_path);
    disp('the energy and X do not coincide')
end

%% output parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Params.X = X_GT;        %matrix n x n, ground trueth/best estimation permutation
Params.E = err_GT;      %int, ground trueth/best estimation energy     
Params.W = W;           %matrix n^2 x n^2, binary term
Params.n = n;           %permutation matrix size 
Params.A = D1;          %distance matrix of graph 1
Params.B = D2;          %distance matrix of graph 2
Params.skip_flag = skip_flag;

end

