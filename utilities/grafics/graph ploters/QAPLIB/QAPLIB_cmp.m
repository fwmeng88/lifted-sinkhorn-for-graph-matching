function [] = QAPLIB_cmp()
load(fullfile('data','analyzed_data','QAPLIB','Qap_results_v5_8.mat'))
Qap_results1 = Qap_results;
load(fullfile('data','analyzed_data','QAPLIB','Qap_results_v5_7.mat'))
Qap_results2 = Qap_results;
name_set = {'bur','chr','els','esc','had','kra','nug','scr','sko','ste','tai','tho','wil'};

mini_plot(Qap_results1,Qap_results2)
end

function mini_plot(data1,data2)
counter = 0;
acurate_sol = [];
for i =  1:length(data1)
    file_name = data1(i).name;
    for j = 1:length(data2)
        if strcmp(file_name,data2(j).name)            
            counter = counter + 1;
            names{counter} = file_name;
            energy1(counter) = data1(i).energy(end);
            energy2(counter) = data2(j).energy(end);
%             t1(counter) = data1(i).time;
%             t2(counter) = data2(j).time;
%             no_iter1(counter) = data1(i).no_iter;
%             no_iter2(counter) = data2(j).no_iter;
            X{counter} = data1(i).X;
            Xp{counter} = data1(i).Xp;
            energy_p1(counter) = data1(i).energy_p;
            energy_p2(counter) = data2(j).energy_p;
            X_GTarr{counter} = data1(i).X_GT;
            err_GTarr(counter) = data1(i).err_GT;
            N(counter) = size(X_GTarr{counter},1);
            err_UB(counter) = data1(i).energy_UB;
            err_LB(counter) = data1(i).energy_LB;
            if energy_p1(counter) - energy1(counter)<1e-3*energy1(counter)
                acurate_sol(:,end+1) = [counter; energy1(counter)];
            end
        end
        
    end
    
    
end
%%%%%%%%%%%%%%%% plot energy'ssss %%%%%%%%%%%%%%%%%%%%%%%%%%
L = 900;
W = 400;
h(1) = figure(1);
set(h(1),'position',[100 800 L W])

semilogy(energy1,'g','LineWidth',1.5)
hold on
semilogy(energy2,'k','LineWidth',1.5)
semilogy(energy_p1,'m','LineWidth',1.5);
semilogy(energy_p2,'c','LineWidth',1.5);
semilogy(err_UB,'-.r','LineWidth',1.5);
semilogy(err_LB,':b','LineWidth',1.5);
scatter(acurate_sol(1,:),acurate_sol(2,:),'filled','r');
ylim([10,10^10])
% hold off
title('energy');
xlabel('exp no.');
ylabel('energy');
legend('my LB1','myLB2','myUB1','myUB2','QAPLIB UB','QAPLIB LB');

h(2) = figure(2);
set(h(2),'position',[100 300 L W])
plot((energy1 - err_LB)./(energy1 + err_LB),'g','LineWidth',1.5)
hold on
plot((energy2 - err_LB)./(energy2 + err_LB),'k','LineWidth',1.5)
plot((energy_p1 - err_UB)./(energy_p1 + err_UB),'m','LineWidth',1.5);
plot((energy_p2 - err_UB)./(energy_p2 + err_UB),'c','LineWidth',1.5);

title('energy divergence');
xlabel('[exp no]')
ylabel('energy divergence');

h(3) = figure(3);
subplot(2,1,1);
histogram(t1/60,100);
title('run time(minutes) for stop condition over X')
subplot(2,1,2);
histogram(t2/60,40);
title('run time(minutes) for stop condition over energy')
% set(h(3),'position',[1000 800 L W])
% scatter(N,t1/60,'filled')
% hold on;
% scatter(N,t2/60,'filled')
% title('run time');
% ylabel('time (minets)');
% xlabel('experiment size');


h(4) = figure(4);
set(h(4),'position',[1000 300 L W])
scatter(N,log(no_iter1),'filled');
hold on
scatter(N,log(no_iter2),'filled');

title('no iterations');
ylabel('energy');
xlabel('# experiment');
end

