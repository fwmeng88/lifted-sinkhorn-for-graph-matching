function goodPlot( params )
% function which produces a nice-looking plot
% and sets up the page for nice printing

%--------------------------------------------
% Default params
%--------------------------------------------
% default params
params.null = [];
figName = getoptions(params, 'figName', 'fig');
paperWidth = getoptions(params, 'paperWidth', 6.5);
paperHeight = getoptions(params, 'paperHeight', 5);
margin = getoptions(params, 'margin', 0.25);
printRes = getoptions(params, 'printRes', 600);
textFontsize = getoptions(params, 'textFontsize', 28);
axisFontSize = getoptions(params, 'axisFontSize', 24);
closeFig = getoptions(params, 'closeFig', false);
legendOuterPosition = getoptions(params, 'legendOuterPosition', [55 55]); % in pixels
legendLocation = getoptions(params, 'legendLocation', 'northeast'); % in pixels
legendFontSize = getoptions(params, 'legendFontSize', 23);
curFig = getoptions(params, 'curFig', gcf);
%============================================
% set current figure
set(0, 'currentfigure', curFig);
% ylim([0 0.02])
% save as figure
% saveas(curFig,figName)
if ~isunix
    % change fonts
    allAxesInFigure = findall(curFig,'type','axes');
    for ii = 1 : length(allAxesInFigure)
        currAxes = allAxesInFigure(ii);
        set(get(currAxes,'xlabel'),'FontSize', textFontsize, 'fontname','Times-Roman');
        set(get(currAxes,'ylabel'),'FontSize', textFontsize, 'fontname','Times-Roman');
        % set(currAxes,'LineWidth',1.5);
        set(currAxes,'FontSize',axisFontSize);
    end
    % change legend
    lh = findobj(curFig,'Tag','legend');
    for ii = 1 : length(lh)
        currLh = lh(ii);
        set(currLh,'units','pixels');
        lp = currLh.Position;
        set(currLh,'Position',[lp(1:2),legendOuterPosition]);
        set(currLh,'FontSize',legendFontSize, 'fontname','Times-Roman');
        set(currLh,'Location',legendLocation);
    end
    % handle the figure size
    set(curFig,'color','w');
    set(curFig,'PaperUnits','inches');
    set(curFig,'PaperSize', [paperWidth paperHeight]);
    set(curFig,'PaperPosition',[margin margin paperWidth-2*margin paperHeight-2*margin]);
    set(curFig,'PaperPositionMode','Manual');
    % create pdf
    printString = sprintf('print -painters -dpdf -r%d %s.pdf',printRes,figName);
    eval(printString);
else
    saveas(curFig, sprintf('%s.jpg',figName))
end
% close figure
if closeFig
    close(curFig)
end
end