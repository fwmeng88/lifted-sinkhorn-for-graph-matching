function PlotResultAfterLocalMinimization(V1,F1,V2,F2,idx1,idx2,title1,title2)
colorVerts = V1(:,idx1)';
scattColor = bsxfun(@rdivide,bsxfun(@minus,colorVerts,min(colorVerts,[],1)), (max(colorVerts,[],1)-min(colorVerts,[],1)));

h = figure(5);
close(h);
h = figure(5);
set(gcf,'Position', [100, 600, 800, 800]);
%subplot(1,2,1)
figure;
title(title1)
params.scattColor = scattColor;
params.verInd  = idx1;
plotMeshAndPoints( V1, F1, params )
camlight
% subplot(1,2,2)
figure;
title(title2)
params.scattColor = scattColor;
params.verInd  = idx2;
plotMeshAndPoints( V2, F2, params )
camlight
end