function [ O_params,E_proc ] = run_optimization_exps5_teeth(parameters)
%load data sets
%create from data distace matrices squareform(pdist(P))
%use my solver to find a permutation between every two pairs
%calculate the loss ||AX-XB||_F

%% init experiment parameters
%extract the prameters from struct (for better redibility)
entropy = parameters.entropy;
stop_critiria = parameters.stop_critiria ;
stop_critiria_sinkhorn = parameters.stop_critiria_sinkhorn ;
max_iterations = parameters.max_iterations;
%explist = parameters.exp_no;


N = 400;% total number of points
n = 50;% mached number of points
data_path = dir(fullfile('data','teeth','DATA','teeth','meshes','*.off'));
% load(fullfile('data','analyzed_data','mashes','teeth_Mat'));
load(fullfile('data','analyzed_data','mashes','teeth data','teeth_preproc'));
load(fullfile('data','analyzed_data','mashes','teeth_Mat'));
for i = 1:numel(data_path)
    %         %%%%%%
    disp(i);
    BABY = fullfile('data','teeth','DATA','teeth','meshes');
    [V{i},F{i}]=read_off(fullfile(BABY,data_path(i).name));
    [area,~] = CORR_calculate_area(F{i}',V{i}');
    V{i} = V{i}'/sqrt(area);
    F{i} = F{i}';
    %     dist{i} = squareform(pdist(V{i}));
    %     lidx{i} = chooseFarthestPoints(dist{i},N); %choose total number of points
    %     sidx{i} = lidx{i}(1:n);
    %    V_smp{i} = V{i}(lidx{i},:);
    %    D{i} = squareform(pdist(V_smp{i}));
end
E_proc_mat = zeros(numel(data_path));
for i = 1:numel(data_path)
    disp(i);
    for j = 1:i-1
         Xp = Xp_cell{i,j}';
%         %construct Xinit
         [~,I1] =  max(Xp,[],2);
%         [~,NNidx1] = min(D{i}(:,1:n),[],2);
%         [~,NNidx2] = min(D{j}(:,I1));
%         X0 = zeros(N,N);
%         X0(sub2ind([N N],(1:N),NNidx2(NNidx1)))=1;
        params.Xinit = ones(N)./N;
        %frank wolfe solver (match sampled points using X init from lifted sinkhorn
        X_fw= frankWolfeSolverHaggai(-D{i},D{j},params);
%         
%         %find procrastes distance
        [~,I3] = max(X_fw,[],2);%indces form X fw


%         I3 = O_params{i,j}.I_fw;
        P = V_smp{i};        
        QX = V_smp{j}(I3,:);
        %subtract avrage
        P_centerd = P - repmat(mean(P),N,1);
        QX_centerd = QX - repmat(mean(QX),N,1);
        %estimate R
        [Um,~,Vm] = svd(P_centerd'*QX_centerd);
        R = Um*Vm';
        
        E_proc = norm(R'*P_centerd' - QX_centerd','fro');
        
        E_proc_mat(i,j) = E_proc;
        
        RP = R'*P_centerd';
        QX = QX_centerd';
        
%         figure(4);
%         scatter3(RP(1,:),RP(2,:),RP(3,:),'filled','r');
%         hold on;
%         scatter3(QX(1,:),QX(2,:),QX(3,:),'b');
%         hold off;
        
        O_params{i,j}.E_proc = E_proc;
        O_params{i,j}.R = R;
        O_params{i,j}.idx1 = i;
        O_params{i,j}.idx2 = j;
        O_params{i,j}.name1 = data_path(i).name;
        O_params{i,j}.I_fw = I3;
        
        %present X GT (from the sinkhorn algorithm)
        PlotResultAfterLocalMinimization(V{i}',F{i}',V{j}',F{j}',lidx{i}(1:n),lidx{j}(I1),'source','target')
        %present Xfw
        PlotResultAfterLocalMinimization(V{i}',F{i}',V{j}',F{j}',lidx{i},lidx{j}(I3),'source','target')
    end
    figure(1);imagesc(E_proc_mat' + E_proc_mat);
end

E_proc = E_proc_mat' + E_proc_mat;

% save('mt1_data','O_params','E_proc');

end

