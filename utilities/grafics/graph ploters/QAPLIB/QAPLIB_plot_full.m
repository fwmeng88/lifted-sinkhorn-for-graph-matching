function [] = QAPLIB_plot_full()
close all
load(fullfile('data','analyzed_data','QAPLIB','Qap_results_v6_2.mat'))  
name_set = {'bur','chr','els','esc','had','kra','nug','scr','sko','ste','tai','tho','wil'};
mini_plot(Qap_results)
end

function mini_plot(data)
counter = 0;
acurate_sol = [];
for i =  1:length(data)
    file_name = data(i).name;
        counter = counter + 1;
        names{counter} = file_name;
        energy(counter) = data(i).energy(end);
        t(counter) = data(i).run_time;
%         no_iter(counter) = data(i).no_iter;
        X{counter} = data(i).X;
        if ~exist('data(i).energy_p_fW')
            data(i).energy_p_fW = nan;
        end
        if data(i).energy_p >  data(i).energy_p_fW
            energy_p(counter) = data(i).energy_p_fW;
            Xp{counter} = data(i).XpfW;
        else
            energy_p(counter) = data(i).energy_p;
            Xp{counter} = data(i).Xp;
        end
        X_GTarr{counter} = data(i).X_GT;
        err_GTarr(counter) = data(i).err_GT;
        N(counter) = size(X_GTarr{counter},1);
        err_UB(counter) = data(i).energy_UB;
        err_LB(counter) = data(i).energy_LB;
        err_GT(counter) = mean([err_UB(counter),err_LB(counter)]);
        if err_LB(counter) - energy(counter)<1e-2*energy(counter)
            acurate_sol(:,end+1) = [counter; (energy(counter)-err_GT(counter))./(err_GT(counter))];
        end
            

end
%%%%%%%%%%%%%%%% plot energy'ssss %%%%%%%%%%%%%%%%%%%%%%%%%%
L = 900;
W = 400;
h(1) = figure(1);
% subplot(2,1,1);
% set(h(1),'position',[00 500 L W])
% 
% semilogy(energy,'g','LineWidth',1.5)
% hold on
% semilogy(energy_p,'m','LineWidth',1.5);
% semilogy(err_UB,'-.r','LineWidth',1.5);
% semilogy(err_LB,':b','LineWidth',1.5);
% scatter(acurate_sol(1,:),acurate_sol(2,:),'filled','r');
% ylim([10,10^10])
% % hold off 
% title('energy');
% xlabel('exp no.');
% ylabel('energy');
% %legend('lifted sinkhorn','lifted sinkhorn proj','QAPLIB UB','QAPLIB LB');

%h(2) = figure(2);
%set(h(2),'position',[00 000 L W])
% subplot(2,1,2)
plot((energy - err_GT)./(err_GT),'g','LineWidth',1.5);
hold on
plot((energy_p - err_GT)./(err_GT),'m','LineWidth',1.5);
%plot((energy_p_fw - err_GT)./(err_GT),'b','LineWidth',1.5);

plot((err_LB - err_GT)./(err_GT),'r','LineWidth',.5);
plot((err_UB - err_GT)./(err_GT),'r','LineWidth',.5);
scatter(acurate_sol(1,:),acurate_sol(2,:),'filled','r');
n = length(energy);
% plot(zeros(n));
%plot(ones(n)*0.1,'r');
% plot(ones(n)*0.01,'r');
%plot(ones(n)*-0.1,'r');
% plot(ones(n)*-0.01,'r');
title('Qap Lib');
xlabel('[exp no]')
ylabel('energy divergence');
% yyaxis right
% scatter(1:n,t/60,N,'filled');
% ylabel('Time (Minutes)');
% set(gca, 'YScale', 'log')
legend('Lower Bound','Upper Bound','QAPLIB LB','QAPLIB UB');
ylim([-1,1]);

h(3) = figure(3);
set(h(3),'position',[800 500 L W])
scatter(N,log10(t/60),'filled')
hold on
title('run time');
ylabel('LOG(time (minets))');
xlabel('experiment size');


% h(4) = figure(4);
% set(h(4),'position',[800 000 L W])
% scatter(N,log(no_iter),'filled');
% hold on
% title('no iterations');
% ylabel('energy');
% xlabel('# experiment');

for i = 1:length(X)
    figure(5);
    subplot(2,2,2);
    imagesc(X{i});
    title1 = strcat('LB _.',num2str(energy(i),3),'_ GT _.',num2str(err_UB(i),3),'_ UB _.',num2str(energy_p(i),3));
    title(title1);
    subplot(2,2,3);
    imagesc(X_GTarr{i});
    title('GT');
    subplot(2,2,4)
    imagesc(Xp{i});
    title('projection');
    subplot(2,2,1)
    imagesc(Xp{i} - X_GTarr{i});
    title(names{i});
    pause;
end
end

