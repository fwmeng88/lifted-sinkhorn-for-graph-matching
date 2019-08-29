function [] = ent2GT()
load('ent2GT.mat');
GT = ent2GT.GT;
E = ent2GT.enrg;
entropy = ent2GT.ent;


figure(1);
semilogx(entropy,E,'r','linewidth',2);
hold on;
semilogx(entropy,GT,'b','linewidth',2);
ylabel('energy')
xlabel('entropy')
legend('P4','GT')
title(file_name);

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
