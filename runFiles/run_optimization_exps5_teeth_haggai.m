function [ O_params ] = run_optimization_exps5_teeth_haggai(parameters)
%load data sets
%create from data distace matrices squareform(pdist(P))
%use my solver to find a permutation between every two pairs
%calculate the loss ||AX-XB||_F

%% init experiment parameters
%extract the prameters from struct (for better redibility)
% entropy = parameters.entropy;
% stop_critiria = parameters.stop_critiria ;
% stop_critiria_sinkhorn = parameters.stop_critiria_sinkhorn ;
% max_iterations = parameters.max_iterations;
%explist = parameters.exp_no;

teeth_idx1 = parameters.teeth_idx1; %idx of first compered tooth
teeth_idx2 = parameters.teeth_idx2; %idx of second compered tooth
N = 400;% total number of points
n = 50;% mached number of points
data_path = dir(fullfile('data','teeth','DATA','teeth','meshes','*.off'));
load(fullfile('data','analyzed_data','mashes','teeth_mat'));
%preporcess, choose set of furthers points on each tooth to match later
for i = [teeth_idx1,teeth_idx2]%:numel(data_path)
    %%%%%%
    BABY = fullfile('data','teeth','DATA','teeth','meshes');
    [V{i},F{i}]=read_off(fullfile(BABY,data_path(i).name));
    [area,~] = CORR_calculate_area(F{i}',V{i}');
    V{i} = V{i}'/sqrt(area);
    F{i} = F{i}';
    dist{i} = squareform(pdist(V{i}));
    lidx{i} = chooseFarthestPoints(dist{i},N); %choose total number of points
    sidx{i} = lidx{i}(1:n);
    
%     V_smp = V{i}(idx{i},:); 
%     D{i} = squareform(pdist(V_smp));
end

for i = teeth_idx1%:numel(data_path)-1
    for j = teeth_idx2%:numel(data_path)
        Xp = Xp_cell{j,i}';
        %construct Xinit
        [~,I1] =  max(Xp,[],1);
        [~,NNidx1] = min(dist{i}(lidx{i},sidx{i}),[],2);
        [~,NNidx2] = min(dist{j}(lidx{j},sidx{j}(I1)));
        X0 = zeros(N,N);
        X0(sub2ind([N N],(1:N),NNidx2(NNidx1)))=1;
        params.Xinit = X0';
        X_fw= frankWolfeSolverHaggai(-dist{i}(lidx{i},lidx{i}),dist{j}(lidx{j},lidx{j}),params);        
        [~,I2] = max(X0,[],2);%indeces from the X init
        [~,I3] = max(X_fw,[],2);%indces form X fw
        %present X GT (from the sinkhorn algorithm)
        PlotResultAfterLocalMinimization(V{i}',F{i}',V{j}',F{j}',sidx{i}(1:n),sidx{j}(I1),'source','target')
        %present Xinit matching
        %PlotResultAfterLocalMinimization(V{i}',F{i}',V{j}',F{j}',lidx{i},lidx{j}(I2),'source','target')
        %present Xfw
        PlotResultAfterLocalMinimization(V{i}',F{i}',V{j}',F{j}',lidx{i},lidx{j}(I3),'source','target')
    end
end

end



function[]= upsample(N,n,mappedIdx2,dist1,dist2,V1,V2)
% generate initialization assignment
[~,NNidx1] = min(dist1(uidx1,idx1),[],2);
[~,NNidx2] = min(dist2(uidx2,mappedIdx2));
X0 = zeros(N,N);
X0(sub2ind([N N],1:N,NNidx2(NNidx1)))=1;
params.Xinit = X0;
uX_proj_new= MRFfrankWolfeSolver(dist1(uidx1,uidx1),dist2(uidx2,uidx2),params);
end
