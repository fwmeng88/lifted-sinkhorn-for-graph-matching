function [Qap_results1] = data_filling(Qap_results1)
load(fullfile('C:','Users','yamk','Dropbox','YAM_sinkorn_matching','data','analyzed_data','QAPLIB','Qap_results'));
Qap_results_GT = Qap_results;
%load(fullfile('data','analyzed_data','QAPLIB','Qap_results.mat'));
%Qap_results_GT = Qap_results;

for i = 1:numel(Qap_results_GT)
    file_name_GT = Qap_results_GT (i).name;
    for j = 1:numel(Qap_results1)
        file_name1 = Qap_results1 (j).name;
        if strcmp(file_name_GT,file_name1) 
            Qap_results1(j).energy_UB = Qap_results_GT(i).err_UB;
            Qap_results1(j).energy_LB = Qap_results_GT(i).err_LB;
        end
    end
end


end

