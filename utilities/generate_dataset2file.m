function generate_dataset2file()
rng(5)
%params -
numInstances = 5;
graphSize  = 100;
numLabels = 2; 
knn = 10;
saveFolder = fullfile(pwd,['dataset_' strrep(strrep(datestr(datetime('now')),' ','_'),':','_')]);
mkdir(saveFolder)
for ii =1:numInstances
    %we drow point in R^2 and conect them acording to auclidian disetance
    points = randn(graphSize,2);
    nidx = knnsearch(points,points,'k',knn+1);
    E = zeros(graphSize);
    % fill in E - adj
    for jj = 1:graphSize
        linIdx = sub2ind([graphSize,graphSize],jj*ones(knn,1),nidx(jj,2:end)');
        E(linIdx) = 1;
    end
    E = (E+E')>0;
    %figure,imagesc(double(E))
    dataCost = round(2*rand(numLabels,graphSize)-1);
    metric = 0.1*(2*rand(numLabels,numLabels)-1);%[0 0.01 ; 0.01 0]; %
    save(fullfile(saveFolder,sprintf...
        ('synthetic_problem_graphSize_%d_numLabels_%d_knn_%d_number_%d.mat',...
        graphSize,numLabels,knn,ii))...
        ,'E','dataCost','metric');
end
end
