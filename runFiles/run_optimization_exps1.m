function [output] = run_optimization_exps1(parameters)
%RUN_OPTIMIZATION_EXPS1  - run over QAPLIB
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
explist = parameters.exp_no;

%%%%%%%%%%%%%%%%%%%% load qaplib file names %%%%%%%%%%%%%%%%%%%%%%%
folder_name = fullfile('code','code v6','datasetHandling','QAPLIB','test_data');
folder_name_GT = fullfile('code','code v6','datasetHandling','QAPLIB','GT');
listing = dir(fullfile(folder_name,'*.mat'));
listing_GT = dir(fullfile(folder_name,'*.mat'));
switch explist
    case 'all'
        EXP_LIST_IND = 1:length(listing);
    otherwise
        EXP_LIST_IND = explist;
end

for i = EXP_LIST_IND 
    %% load Data 
    file_name = listing(i).name;
    disp(file_name);
    if strcmp(file_name,'tai256c.mat')
        continue;
    end
%     disp(i)
    file_path = fullfile(folder_name,file_name);
    file_path_GT = fullfile(folder_name_GT,file_name);
    QapParam= name2W_QAPLIB( file_path,file_path_GT  );
    
    %% run experiments
%     QapParam
    if ~QapParam.skip_flag
        PMD_params.energy_GT = QapParam.E;
        PMD_params.stop_critiria = stop_critiria;
        PMD_params.stop_critiria_sinkhorn = stop_critiria_sinkhorn;
        PMD_params.entropy = entropy;
        PMD_params.Z = zeros(QapParam.n);
        PMD_params.W = QapParam.W;
        PMD_params.A = QapParam.A;
        PMD_params.B = QapParam.B;
        PMD_params.type = 'permutation';
        PMD_params.n = QapParam.n;
        PMD_params.m = QapParam.n;
        PMD_params.max_iterations = max_iterations;
        PMD_params.sparse = false;
        PMD_params.Adj = [];
        PMD_params.graphics = parameters.graphics;
    
        
       [ O_params] = PMD_sinkhorn( PMD_params );
        output(i) = O_params;
    else
       % output(i) = [];
    end
    output{i}.A = PMD_params.A;
    output{i}.B = PMD_params.B;
    output{i}.name = file_name;
    
end

end

