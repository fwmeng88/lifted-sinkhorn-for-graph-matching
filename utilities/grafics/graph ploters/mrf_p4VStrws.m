function [ ] = mrf_p4VStrws( )
%MRF_PLOTER Summary plot comperisons between trws and us on a 1000x2 data
load('code\datasetHandling\analyzed data\TRWS\1000_2abcd\1000x2_all.mat')

colors = get(groot,'DefaultAxesColorOrder');



thrsh = 10^-3;
rel_dif = abs(Ey - E1)./abs(Ey);
E1 = E1(rel_dif > thrsh);
Ey = Ey(rel_dif > thrsh);
LB_trws = LB_trws(rel_dif > thrsh);
LB_y = LB_y(rel_dif > thrsh);

%subtract our lower bound
tosub = 0;%LB_y;
E1 = E1 - tosub;
Ey = Ey - tosub;
LB_trws = LB_trws - tosub;
LB_y = LB_y - tosub;

[~,I] = sort(Ey);


figure(1)
plot(rel_dif(abs(rel_dif)>thrsh));


figure(2); title('upper bounds');
%plot(E1(I),'m')
clf;
hold on;
%plot(Ey(I),'g');
plot(E1(I),'color',colors(1,:),'linewidth',1.5);
plot(Ey(I),'color',colors(5,:),'linewidth',1.5);


ylabel('Energy');
xlabel('Experiment');
legend('UB sinkhorn','UB trws');%'LB trws','LB sinkhorn');
hold off
ylim([min([E1(:); Ey(:)]) max([E1(:); Ey(:)])]);
goodPlot;



%subtract our lower bound
tosub = LB_y;%LB_y;
E1 = E1 - tosub;
Ey = Ey - tosub;
LB_trws = LB_trws - tosub;
LB_y = LB_y - tosub;

[~,I] = sort(Ey);


figure(4)
%plot(E1(I),'m')
clf;hold on;
%plot(LB_trws(I),'r');
 plot(LB_trws(I),'color',colors(2,:));
 %hold on;
% %plot(LB_y(I),'b');
 plot(LB_y(I),'color',colors(4,:));
 plot(E1(I),'color',colors(1,:));%,'linewidth',1.5);
plot(Ey(I),'color',colors(5,:));%,'linewidth',1.5);

ylabel('Energy');
xlabel('Experiment');
legend('LB trws','LB sinkhorn','UB trws','UB sinkhorn');
hold off
% ylim([min([LB_trws(:); LB_y(:)]) max([LB_trws(:); LB_y(:)])]);

end

