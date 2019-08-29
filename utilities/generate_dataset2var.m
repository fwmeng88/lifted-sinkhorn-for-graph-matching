function [metric,U,E] = generate_dataset2var(graphSize,numLabels,knn,randSeed)
rng(randSeed)
%params -

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
dataCost = abs(round(2*rand(numLabels,graphSize)-1)) + 0.5;
metric = 0.1*(2*rand(numLabels,numLabels)-1);%[0 0.01 ; 0.01 0]; %

U = dataCost';
%W = kron(metric,E);
end
