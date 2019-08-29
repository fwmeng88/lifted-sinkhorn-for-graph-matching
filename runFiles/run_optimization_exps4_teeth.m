function [ O_params ] = run_optimization_exps4_teeth(parameters)
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

n = 50;
data_path = dir(fullfile('data','teeth','DATA','teeth','meshes','*.off'));
for i = 1:numel(data_path)%[11,13]
    %%%%%%
    BABY = fullfile('data','teeth','DATA','teeth','meshes');
    [V{i},F{i}]=read_off(fullfile(BABY,data_path(i).name));
    [area,~] = CORR_calculate_area(F{i}',V{i}');
    V{i} = V{i}'/sqrt(area);
    F{i} = F{i}';
    dist = squareform(pdist(V{i}));
    idx{i} = chooseFarthestPoints(dist,n);
    V_smp = V{i}(idx{i},:);
    D{i} = squareform(pdist(V_smp));
end

PMD_params.stop_critiria = stop_critiria;
PMD_params.stop_critiria_sinkhorn = stop_critiria_sinkhorn;
PMD_params.max_iterations = max_iterations;
PMD_params.entropy = entropy;
PMD_params.Z = zeros(n);
PMD_params.type = 'permutation';
PMD_params.n = n;
PMD_params.m = n;
PMD_params.sparse = false;
PMD_params.Adj = [];
PMD_params.graphics = parameters.graphics;

for i = 1:numel(data_path)-1%11
    for j = 1:numel(data_path)%13
        tic
        disp('match btween - ');
        disp([i,j]);
        PMD_params.W = kron(-D{i},D{j});
        PMD_params.A = -D{i};
        PMD_params.B = D{j};
        [ O_params] = PMD_sinkhorn( PMD_params );
        Xp = O_params.Xp ;
        %%%%%%%%%%%%%% remove if you see this %%%%%%%%%
        T(i,j) = toc;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        energy3 = norm(D{i}*Xp - Xp*D{j},'fro');
        [~,I1] =  max(O_params.Xp,[],1);
        O_params.energy3 = energy3;
        PlotResultAfterLocalMinimization(V{i}',F{i}',V{j}',F{j}',idx{i},idx{j}(I1),'source','target')
        %%%%%%%% remove if you see this %%%%%%%%%%%%%%%%
        save('solution_time_matrix_teeth','T')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end



end

