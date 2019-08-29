function [] = scalability(n,t)
load('t_vs_n5.mat')
Tlp= mean(T.lp,2);
Tsdp = mean(T.sdp,2);
Tp4_a = mean(T.p4_a,2);
Tp4_b = mean(T.p4_b,2);
Tp4_c = mean(T.p4_c,2);
Tp4_d = mean(T.p4_e,2);
f = figure(1);
set(f,'DefaultAxesFontName', 'david')
pja = plot(N(1:length(Tlp)),Tlp,'r','LineWidth',2);
hold on;
pjaz = plot(N(1:length(Tsdp)),Tsdp,'g','LineWidth',2);
pp41 = plot(N(1:length(Tp4_a)),Tp4_a,'m','LineWidth',2);
pp42 = plot(N(1:length(Tp4_b)),Tp4_b,'b','LineWidth',2);
pp43 = plot(N(1:length(Tp4_c)),Tp4_c,'c','LineWidth',2);
pp43 = plot(N(1:length(Tp4_d)),Tp4_d,'LineWidth',2);
scatter(n,t,'filled','g');
ylim([0,900]);
%title('run time vs graph size')
xlabel('n','FontSize', 20);
ylabel('t(sec)','FontSize', 20);
l = legend('LP JA','SDP JA','p4 a','p4 b','p4 c','p4 d');
hold off




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% some grafics stuff %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.null = [];
curFig = getoptions(params, 'curFig', gcf);
textFontsize = getoptions(params, 'textFontsize', 3);
axisFontSize = getoptions(params, 'axisFontSize', 15);
allAxesInFigure = findall(curFig,'type','axes');

currAxes = allAxesInFigure(1);
set(get(currAxes,'xlabel'),'FontSize', 30, 'fontname','Times-Roman');
set(get(currAxes,'ylabel'),'FontSize', 30, 'fontname','Times-Roman');
% set(currAxes,'LineWidth',1.5);
set(currAxes,'FontSize',axisFontSize);



%legend stuff
legendOuterPosition = getoptions(params, 'legendOuterPosition', [55 55]); % in pixels
legendLocation = getoptions(params, 'legendLocation', 'southeast'); % in pixels
legendFontSize = getoptions(params, 'legendFontSize', 12);

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
