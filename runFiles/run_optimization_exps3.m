function [output] = run_optimization_exps3(parameters)
%RUN_OPTIMIZATION_EXPS3  - test a 2x1000 data set using the lifted_sinkhorn_solver
%INPUT
%   parameters - struct 
%           max_iter- int, maximal number of iterations 
%           entropy - double, enrtopy wight in the energy term 
%           stop_critiria - double, stopping cratiria for the algorithm distance in infinitiy norm between (Xn - Xn+1) ). regular term 10^-4;

%   output - struct arr
%           X - matrix n x n, X part in argmin of energy term
%           Y - tenzor n x n x n x n , Y part in argmin of energy term
%           X_projected - matrix n x n, estimated permuation 
%           no_iterations - int, nuber of iteration lifted_sinkhorn took to
%                           converge
%           energy_LB - double, energy of the given solution X,Y (of the
%                       relaxed problem)
%           energy_UB - double, energy of the estimated permutation of the
%                       original ptoblem 
%% init experiment parameters
rng(2); %set random seed
%extract input parameters (for better readability)
entropy = parameters.entropy;
stop_critiria = parameters.stop_critiria;
max_iterations = parameters.max_iter;

%% load sinthetic data names 
folder_name = fullfile('datasetHandling','kolom','dataset_10_1000_2x 250a');
listing = dir(fullfile(folder_name,'*.mat'));

for i = 1:length(listing)
    load(fullfile(folder_name,listing(i).name));    %load file data
    W = kron(metric,E);                             %binary energy term 
    U = dataCost';                                  %unary energy term 
    [n,m] = size(U);                                %asignment matrix dimension
    
    %load parameters for LS solver
    LS_params.max_iterations = max_iterations;
    LS_params.stop_critiria = stop_critiria;
    LS_params.W = W;
    LS_params.Z = U;
    LS_params.type = 'labelling';
    LS_params.entropy = entropy;
    LS_params.n = n;
    LS_params.m = m;

    [ O_params] = PMD_sinkhorn( LS_params ); %LS solver ingage!!!
    output(i) = O_params; %save experimant data to the output array

end

end

