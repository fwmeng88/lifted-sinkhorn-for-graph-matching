function [output] = run_optimization_exps2(parameters)
%RUN_OPTIMIZATION_EXPS2  - run over chinese latters
%INPUT
%   parameters - struct
%           max_iter- int, maximal number of iterations
%           entropy - double, entropy weight in the energy term
%           stop_critiria - double, stopping criteria for the algorithm distance in infinity norm between (Xn - Xn+1) ). regular term 10^-4;
%   output - struct arr
%           X - matrix n x m, X part in argmin of energy term
%           Y - tenzor n x m x n x m , Y part in argmin of energy term
%           X_projected - matrix n x m, estimated permutation
%           no_iterations - int, number of iteration lifted_sinkhorn took to
%                           converge
%           energy_LB - double, energy of the given solution X,Y (of the
%                       relaxed problem)
%           energy_UB - double, energy of the estimated permutation of the
%                       original problem



%% init experiment parameters
%extract the prameters from struct (for better redibility)
entropy = parameters.entropy;
stop_critiria = parameters.stop_critiria ;
stop_critiria_sinkhorn = parameters.stop_critiria_sinkhorn ;
max_iterations = parameters.max_iterations;

%%%%%%%%%%%%%%%%%%%% load chinese file names %%%%%%%%%%%%%%%%%%%%%%%
folder_name = fullfile('datasetHandling','kolomogrov','chinese','models');
folder_name_GT = fullfile('datasetHandling','kolomogrov','chinese','GT');
listing = dir(fullfile(folder_name,'*.mat'));
listing_GT = dir(fullfile(folder_name_GT,'*.png'));

for i = 9%:length(listing)
    %% load Data 
    file_name = listing(i).name;
    file_name_GT = listing_GT(i).name;
    file_path = fullfile(folder_name,file_name);
    file_path_GT = fullfile(folder_name_GT,file_name_GT);
    chinese_params = calcW_meirav( file_path,file_path_GT);
    
    %% run experiments
    PMD_params.stop_critiria = stop_critiria;
    PMD_params.stop_critiria_sinkhorn = stop_critiria_sinkhorn;
    PMD_params.Z = chinese_params.Z ;
    PMD_params.W = chinese_params.W;
    PMD_params.n = chinese_params.n; %the dimensions of unknown X
    PMD_params.m = chinese_params.m;
    PMD_params.Adj = chinese_params.Adj;
    PMD_params.type = 'labelling';
    PMD_params.entropy = entropy;
    PMD_params.max_iterations = max_iterations;
    PMD_params.graphics = true;
    PMD_params.sparse = true;
    [ O_params ] = PMD_sinkhorn( PMD_params );
    output(i) = O_params;
end