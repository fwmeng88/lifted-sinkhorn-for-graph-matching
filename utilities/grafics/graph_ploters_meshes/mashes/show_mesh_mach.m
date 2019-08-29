function [ output_args ] = show_mesh_mach( )
mesh_path = fullfile('data','teeth','DATA','mt1','meshes');
load(fullfile('data','analyzed_data','mashes','mt1_labels.mat'));
load(fullfile('data','analyzed_data','mashes','teeth data','mt1_data.mat'));
load(fullfile('data','analyzed_data','mashes','teeth data','mt1_preproc.mat'));
set_names = dir(fullfile(mesh_path,'*.off' )); 
% labels = teeth_labels;
%    Dist =1;
Dist = E_proc;
n = length(Dist);
ind = sub2ind([n,n],1:n,1:n);
Dist(ind) = inf;
S = [0 0 0];
h = figure(3);
for j_samp = 1:length(Dist)
    [~,idxs] = sort(Dist(j_samp,:));
    j_mins = idxs(1:3);
    J_samp = get_ind(set_names(j_samp).name,labels.names); 
    for i= 1:length(j_mins)
    J_min(i) = get_ind(set_names(j_mins(i)).name,labels.names); 
    end
    if j_mins(1)<j_samp
        match_ind1 = O_params{j_samp,j_mins(1)}.I_fw;
        match_ind2 = 1:400;
    else
        match_ind1 = 1:400;
        match_ind2 = O_params{j_mins(1),j_samp}.I_fw;
    end
    idx1 = lidx{j_samp};
    idx2 = lidx{j_mins(1)};
    [V1,F1]=read_off(fullfile(mesh_path,set_names(j_samp).name));
    [V2,F2]=read_off(fullfile(mesh_path,set_names(j_mins(1)).name));
    PlotResultAfterLocalMinimization(V1,F1,V2,F2,idx1(match_ind2),idx2(match_ind1),'source','target')
    disp(labels.label(J_samp,:));% 4 teeth and mt1
    %disp(labels.label(J_samp))% 4 radius 
    disp('---------');
    disp(labels.label(J_min,:));% 4 teeth and mt1
    %disp(labels.label(J_min));% 4 radius
    disp('+++++++++++');
     L_samp = labels.label(J_samp,:);
     L_min = labels.label(J_min(1),:);
     S1 =  strcmp(L_samp,L_min);
     S = S + S1;
end
baby = S./[61,61,59]%[116,106,99]
end

function J = get_ind(name,labels_names)
% Get_IND find the index in the distance matrix table corospanding to the  
%  one in the labels tabel 
     
     flag = false;
     for i = 1:length(labels_names)
        if ~isempty(strfind(name,labels_names{i})) || ~isempty(strfind(name,upper(labels_names{i})))...
                ||~isempty(strfind(upper(name),labels_names{i})) 
            J = i;
            flag = true;
            break;
        end
     end
end

function J = show_mach_mash(F1,F2,V1,V2,idx1,idx2,match_ind)
    
PlotResultAfterLocalMinimization(V1',F1',V2',F2',idx1,idx2(I1),'source','target')
end
