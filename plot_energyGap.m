function [ ] = plot_energyGap(  )
%PLOT_ENERGYGAP plot energy and energy gaps between upper and lower bounds
load(fullfile('data','analyzed_data','mashes','teeth_mat'));
figure
subplot(3,1,1);
imagesc(Dist_oj)
title('X teeth');
subplot(3,1,2)
imagesc(Dist_p)
title('projected teeth');
Gap = (Dist_p - Dist_oj)./(Dist_oj.*Dist_p).^(1/2);
subplot(3,1,3);
imagesc(Gap)
title('gap histogram teeth');
figure
histogram(Gap,1000);
title('hist teeth');
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(fullfile('data','analyzed_data','mashes','mt1_Mat'));
figure
subplot(3,1,1);
imagesc(Dist_oj)
title('X mt1');
subplot(3,1,2)
imagesc(Dist_p)
title('projected mt1');
Gap = (Dist_p - Dist_oj)./(Dist_oj.*Dist_p).^(1/2);
subplot(3,1,3);
imagesc(Gap)
title('gap mt1')
figure
histogram(Gap,1000);
title('gap histogram mt1');
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(fullfile('data','analyzed_data','mashes','radius_Mat'));
figure
subplot(3,1,1);
imagesc(Dist_oj)
title('X radius')
subplot(3,1,2)
imagesc(Dist_p)
title('projected radius')
Gap = (Dist_p - Dist_oj)./(Dist_oj.*Dist_p).^(1/2);
subplot(3,1,3);
imagesc(Gap)
title('Gap radius')
figure
histogram(Gap,1000);
title('gap histogram radius');


end

