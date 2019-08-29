function [] = ent2JA()
load('datasetHandling\analyzed data\entropy_conv2_JA.mat')  
% Entropy_arr = data.Entropy_arr;
% ERRja = data.ERRja;
% ERR4 = data.ERRs;

figure(1);
close
figure(1)
semilogx(Entropy_arr,ERRja,'r','linewidth',2);
hold on;
semilogx(Entropy_arr,ERR4sc4,'linewidth',2);
semilogx(Entropy_arr,ERR4sc6,'linewidth',2);
scatter(Entropy_arr(4),ERR4sc4(4),100,'r','filled');
scatter(Entropy_arr(4),ERR4sc6(4),50,'g','filled');
scatter(Entropy_arr(9),ERR4sc4(9),90,'b','filled');
scatter(Entropy_arr(9),ERR4sc6(9),50,'m','filled');

%plot(1./Entropy_arr,ERRs2);
title('entropy vs energy');
xlabel('entropy');
ylabel('energy');
legend('JA','P4 sc e-4','P4 sc e-6');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% some grafics stuff %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.null = [];
curFig = getoptions(params, 'curFig', gcf);
axisFontSize = getoptions(params, 'axisFontSize', 16);
allAxesInFigure = findall(curFig,'type','axes');
currAxes = allAxesInFigure(1);
set(get(currAxes,'xlabel'),'FontSize', 20, 'fontname','Times-Roman');
set(get(currAxes,'ylabel'),'FontSize', 20, 'fontname','Times-Roman');

% set(currAxes,'LineWidth',1.5);
set(currAxes,'FontSize',axisFontSize);



%legend stuff
legendOuterPosition = getoptions(params, 'legendOuterPosition', [55 55]); % in pixels
legendLocation = getoptions(params, 'legendLocation', 'northwest'); % in pixels
legendFontSize = getoptions(params, 'legendFontSize', 15);

lh = findobj(curFig,'Tag','legend');
currLh = lh(1);
set(currLh,'units','pixels');
lp = currLh.Position;
set(currLh,'Position',[lp(1:2),legendOuterPosition]);
set(currLh,'FontSize',legendFontSize, 'fontname','Times-Roman');
set(currLh,'Location',legendLocation);

%paper stuff
paperWidth = getoptions(params, 'paperWidth', 6.5);
paperHeight = getoptions(params, 'paperHeight', 5);
margin = getoptions(params, 'margin', 0.25);
printRes = getoptions(params, 'printRes', 600);

set(curFig,'color','w');
set(curFig,'PaperUnits','inches');
set(curFig,'PaperSize', [paperWidth paperHeight]);
set(curFig,'PaperPosition',[margin margin paperWidth-2*margin paperHeight-2*margin]);
set(curFig,'PaperPositionMode','Manual');

end