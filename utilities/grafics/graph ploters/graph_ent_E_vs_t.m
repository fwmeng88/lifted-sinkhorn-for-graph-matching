load('ent_E_vs_t2.mat')
Es = ERR.sym(:,1);
E4 = ERR.p4(:,1);
Ts = T.sym(:,1);
T4 = T.p4(:,1);
f = figure(3);
set(f,'DefaultAxesFontName', 'ariel')
plot(Ts,Es,'g','LineWidth',2);
hold on;
plot(T4,E4,'b','LineWidth',2);

title('energy vs time for differant entropy' ,'FontSize', 20);
xlabel('T(sec)','FontSize', 20);
ylabel('E','FontSize', 20);
l = legend('symmetric','4 projections');
set(l,'FontSize',12);