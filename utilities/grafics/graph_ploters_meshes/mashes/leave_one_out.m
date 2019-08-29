 function [ output_args ] = leave_one_out( )
mesh_path = fullfile('data','teeth','DATA','teeth','meshes');
load(fullfile('data','analyzed_data','mashes','teeth_labels.mat'));
load(fullfile('data','analyzed_data','mashes','teeth_Mat.mat'));
set_names = dir(fullfile(mesh_path,'*.off' )); 
labels = teeth_labels;
%    Dist =1;
Dist = E_proc;
n = length(Dist);
ind = sub2ind([n,n],1:n,1:n);
Dist(ind) = inf;
S = [0 0 0];
h = figure(3);

for j_samp = 1:length(Dist)
    [~,idxs] = sort(Dist(j_samp,:));
    j_mins = idxs(1);
    J_samp = get_ind(set_names(j_samp).name,labels.names); 
    for i= 1:length(j_mins)
    J_min(i) = get_ind(set_names(j_mins(i)).name,labels.names); 
    end
%     [V_samp,F_samp]=read_off(fullfile(mesh_path,set_names(j_samp).name));
%     [V_min,F_min]=read_off(fullfile(mesh_path,set_names(j_mins).name));
%     close(h)
%    h=  figure(3);
%     subplot(1,2,1)
%      plotMeshAndPoints(V_samp,F_samp,[])
%      camlight
%      title('surce');
%      hold off
%      subplot(1,2,2)
%      plotMeshAndPoints(V_min,F_min,[])
%      title('target');
%      camlight
%      hold off
% %     disp(labels.label(J_samp,:)); 4 teeth and mt1
%     disp(labels.label(J_samp))% 4 radius 
%     disp('---------');
%     %disp(labels.label(J_min,:)); 4 teeth and mt1
%     disp(labels.label(J_min)); 4 radius
%     disp('+++++++++++');
     L_samp = labels.label(J_samp,:);
     L_min = labels.label(J_min,:);
     S1 = L_samp==L_min;
     S = S + S1;
end
baby = S./[116,106,99]%[61,61,59]%
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
