
%cd '\\MATH03-LX\nadavd\data\Results\JustinExp\JusinExp_n=200_hystNum=10_justinRandom=1000_2016-09-12-11-28-56';

%this seems to be the correct one:
cd '\\MATH03-LX\nadavd\data\Results\JustinExp\JusinExp_n=200_hystNum=10_justinRandom=1000_linTermWeight=2_2016-11-08-14-57-27';

%--------------------------------------------
% Default params
%--------------------------------------------
% default params
%onlyTopK=50; %plot only best K of Justins
immortalize=false; %true means saving for article
doPlot=true; %plot comparsion of justin representative vs. ours
params.null = [];
comparedFolder = getoptions(params, 'comparedFolder', pwd); % folder to process
verbose = getoptions(params, 'verbose', 1); % print stuff
%============================================
% verbose
if verbose
    dispFun(['Gathering results... (' comparedFolder ')']);
end


%--------------------------------------------
% Folder content
%--------------------------------------------
resFiles = dir([comparedFolder '/SM*.mat']);

resFiles = natsort({resFiles.name});
if isempty(resFiles),
    warning('Empty folder')
    return
end

L=length(resFiles);
curRes = fullfile(comparedFolder,resFiles{1});
res = load(curRes);
result=res.result;
justinNum=length(result.JustinX_projCell); %no. of random Justin stuff
ourFinalObj=inf(1,L);
justinBestObj=inf(1,L);
allJustinObj=inf(justinNum,L);
ourX_proj=cell(1,L);
resCell=cell(1,L);
justinX_proj=cell(justinNum,L);
paramsCell=cell(1,L);
%Percentiles={10,50,90};
%percentileColors={'r--','r_.','r:'};
%p=length(Percentiles);
%justinPercentiles=inf(p,L);
parfor ii = 1 : L
    if verbose && ~mod(ii,10)
        fprintf('%d/%d - ',ii,length(resFiles));
    end
    curRes = fullfile(comparedFolder,resFiles{ii});
    % load result
    res = load(curRes);
    result=res.result;
    resCell{ii}=result;
end

parfor ii=1:L
    result=resCell{ii};
    params=result.params;
    params.injective=false;
    paramsCell{ii}=params;
    %ourFinalObj(ii)=result.OurFinalObj;
    ourFinalObj(ii)=computeFunctionalWithLinear(result.X_opt,params);
    ourX_proj{ii}=result.OurX_proj;
    justinX_proj(:,ii)=result.JustinX_projCell';
    %allJustinObj(:,ii)=result.JustinFinalObj;
    currentJustinObj=inf(justinNum,1);
    for jj=1:justinNum
       currentJustinObj(jj)=computeFunctionalWithLinear(result.X_optCell{jj},params); 
    end
    sortedJustinTemp=sort(currentJustinObj);
    allJustinObj(:,ii)=currentJustinObj;
    justinBestObj(ii)=sortedJustinTemp(1);
    justinWorstObj(ii)=sortedJustinTemp(end);
    
    %for debugging only
    %   for jj=1:p
    %      percentileInd=round(Percentiles{jj}/100*justinNum);
    %      justinPercentiles(jj,ii)=sortedJustinTemp(percentileInd);
    %   end
    
    
end

%--------------------------------------------------------------------------
%random objectives (to use as baseline)
%--------------------------------------------------------------------------
n=paramsCell{1}.n;
allRandomObj=inf(justinNum,L);
parfor ii=1:justinNum
    Xinit=sinkhornProjSlowFast(rand(n));
    for jj=1:L
        allRandomObj(ii,jj)=computeFunctionalWithLinear(Xinit,paramsCell{jj});
    end 
end
meanRandomObj=inf(1,L);
for jj=1:L
meanRandomObj(jj)=mean(allRandomObj(:,jj));
end
%--------------------------------------------
% plot
%--------------------------------------------
LineWidth=3;
doSort=true;
%Names={'justin best random','totally random (mean)','ours'};
Names={'justin best random','ours'};

if doSort
    %[~,sortedI]=sort((justinBestObj-ourFinalObj)./(meanRandomObj-ourFinalObj));
    [~,sortedI]=sort(justinBestObj-ourFinalObj);
    meanRandomObj=meanRandomObj(sortedI);
    ourFinalObj=ourFinalObj(sortedI);
    justinBestObj=justinBestObj(sortedI);
    justinWorstObj=justinWorstObj(sortedI);
    allJustinObj=allJustinObj(:,sortedI);
    resCell=resCell(sortedI);
end


%objective figure
figure;
hold on
%plot((justinBestObj-ourFinalObj)./(meanRandomObj-ourFinalObj),'r','LineWidth',LineWidth);
plot(justinBestObj-ourFinalObj);
%plot(meanRandomObj-ourFinalObj);
plot(zeros(1,L),'b','LineWidth',LineWidth);

% for jj=1:length(Percentiles)
%    plot(justinPercentiles(jj,:)-ourFinalObj,percentileColors{jj} )
% end
legend(Names);
for ii=1:L
    %vec2plot=(allJustinObj(:,ii)-ourFinalObj(ii))./(meanRandomObj(ii)-ourFinalObj(ii));
    vec2plot=allJustinObj(:,ii)-ourFinalObj(ii);
    vec2plot=sort(vec2plot,'ascend');
    %vec2plot=vec2plot(1:onlyTopK);
    scatter(ii*ones(1,length(vec2plot)),vec2plot,'r','fill');
end
a=gca;
%a.YLim=[-100, a.YLim(2)];
a.YLim=[-100, 1000];
baseline=mean(meanRandomObj-ourFinalObj);
Title=sprintf('Our projection vs %d random initializations. baseline=%d',length(allJustinObj(:,1))),round(baseline);
title(Title);


if immortalize
    figureParams=[];
    figureParams.figName='C:\Users\nadavd\Dropbox\SDP_realxation_with_socp\paper\figs\evaluation_justin\justinCandidate';
    figureParams.printRes=50;
    figureParams.paperWidth=15;
    figureParams.paperHeight=10;
    goodPlot(figureParams);
end
%save grouped results
%save('AllData','ourFinalObj','justinBestObj','allJustinObj','ourX_proj','justinX_proj');

%plot our result vs. justin result from an index where we won

%SELECTED: INTERMODEL=0 FAUSTPAIRNUM=3
if doPlot
    %first graph: point distributions
    assert(doSort);
    ind=L;
    result=resCell{ind};
    params=result.params;
    vidx2=result.vidx2;
    vidx1=result.vidx1;
    %find justins best
    [val,bestInd]=min(allJustinObj(:,ind));
    justinX=result.X_optCell{bestInd};
    %find justins worse
    %     warning('using justins worst');
    %     [val,worseInd]=max(allJustinObj(:,ind));
    %justinX=result.X_optCell{worseInd};
    ourX=result.X_opt;
    %find meshes
    params.faustInterModel=result.interModel;
    params.faustPairNum=result.faustPairNum;
    %faustInterModel = getoptions(params, 'faustInterModel', true);
    %faustPairNum = getoptions(params, 'faustPairNum', 1);
    [V1,~,~,V2,~,~] = getFaustAlignedPair(params);
    %plot
    points2plot=1:10; %points to plot fuzzy correspondence for
    for p=points2plot
        justinTargetDist=justinX(p,:);
        %justinTargetDist=justinTargetDist/max(justinTargetDist);
        ourTargetDist=ourX(p,:);
        %ourTargetDist=ourTargetDist/max(ourTargetDist);
        plotFaustDistribution(p,justinTargetDist,vidx2,vidx1,V2,V1);
        title(sprintf('justin point=%d',p));
        plotFaustDistribution(p,ourTargetDist,vidx2,vidx1,V2,V1);
         title(sprintf('ours point=%d',p));
    end
    %second graph: projected result
    justinX_proj = closestPermutation(justinX);
    ourX_proj = closestPermutation(ourX);
    justinIdx1=justinX_proj*vidx1;
    ourIdx1=ourX_proj*vidx1;
    PlotResultAfterLocalMinimization_faust(V2,V1,vidx2,justinIdx1);
    title('justin');
    PlotResultAfterLocalMinimization_faust(V2,V1,vidx2,ourIdx1);
    title('ours');
end

%%send to VTK
%create an array tosave with fields:
% V1,F1,V2,F2,targetPoints,sourcePoint,scores
papaFolder=pwd;
points2save=[8];
[toSave(1).V1,toSave(1).F1,toSave(1).V2,toSave(1).F2]=getFaustMeshes(params);   %load meshes
[V1,V2]=getFaustCloudsUnmoved(params);
for p=points2save
    M=max(max(justinX(p,:)),max(ourX(p,:)));
    cd(papaFolder);
    newFolder=sprintf('justin_point_no_%d',p);
    mkdir(newFolder);
    cd(newFolder);
    
    toSave.targetPoints=V1(:,vidx1);
    toSave.sourcePoint=V2(:,vidx2(p));
    %create VTK file for justin
    cd(papaFolder);
    newFolder=sprintf('justin_point_no_%d',p);
    mkdir(newFolder);
    cd(newFolder);
    justinToSave=toSave;
    justinToSave.scores=justinX(p,:)/M;
    createVTKFaust(justinToSave);
    %create VTK file for us
    cd(papaFolder);
    newFolder=sprintf('our_point_no_%d',p);
    mkdir(newFolder);
    cd(newFolder);
    ourToSave=toSave;
    ourToSave.scores=ourX(p,:)/M;
    createVTKFaust(ourToSave);
end
cd(papaFolder);



