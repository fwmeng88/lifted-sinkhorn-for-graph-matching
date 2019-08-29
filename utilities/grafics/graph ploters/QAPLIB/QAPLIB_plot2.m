function [] = QAPLIB_plot2()
close all
load(fullfile('data','analyzed_data','QAPLIB','Qap_results_v6_3.mat'))  
name_set = {'bur','chr','esc','had','nug',{'scr','kra','wil'},'sko',{'ste','tho','els'},'tai','lipa'};
j = 0;
L = 1080;
W = 720;
for a = 50:590:1800
    for b = 50:470:1600
        j = j + 1;
        h(j) = figure(j);
        
        set(h(j),'position',[50 50 L W])
        title(name_set{j});
        legend('p4','p4 projected','Lower bound','Uper bound','run time')
        ylabel('energy');
        xlabel('# experiment');
        mini_plot(Qap_results,name_set{j},j)
%         hold on;
%         mini_plot(Qap_results2,name_set{j},j)
goodPlot
        
    end
end
end
function mini_plot(data,set_name,no_fig)
counter = 0;
for i =  1:length(data)
    file_name = data(i).name;
    if contains(file_name,set_name)
        counter = counter + 1;
        
        if counter == 11   
        if contains(file_name,'chr')
        end
        end
        
        names{counter} = file_name;
        energy(counter) = data(i).energy(end);
        t(counter) = data(i).run_time;
%         no_iter(counter) = data(i).no_iter;
        X{counter} = data(i).X;
        Xp{counter} = data(i).Xp;
        energy_p(counter) = data(i).energy_p;
        X_GTarr{counter} = data(i).X_GT;
        err_GTarr(counter) = data(i).err_GT;
        N(counter) = size(X_GTarr{counter},1);
        err_UB(counter) = data(i).energy_UB;
        err_LB(counter) = data(i).energy_LB;
%         subplot(2,1,1);
%         imagesc(X{counter})
%         subplot(2,1,2);
%         imagesc(Xp{counter})
        
    end
end
%%%%%%%%%%%%%%%% plot energy'ssss %%%%%%%%%%%%%%%%%%%%%%%%%%
if counter
    figure(no_fig)
    plot(energy,'g','LineWidth',1.5)
    hold on
    plot(energy_p,'m','LineWidth',1.5);
    plot(err_UB,'-.r','LineWidth',1.5);
    plot(err_LB,':b','LineWidth',1.5);
    title(set_name);
    ylabel('energy');
    yyaxis right
%     legend('Lower Bound','Upper Bound','QAPLIB LB','QAPLIB UB','time');
    scatter(1:size(energy,2),t/60,N,'filled');
    ylabel('Time (Minutes)');
    set(gca, 'YScale', 'log')
    %legend('time');
    hold off
end
% figure(no_fig + 1)
% scatter(N,t/60,'filled')
% hold on
% title('run time');
% legend('p4','Upper bound','Lower bound')
% ylabel('time (minets)');
% xlabel('experiment size');
% hold off 
% 
% 
% figure(no_fig + 2)
% scatter(N,log(no_iter),'filled');
% hold on
% % semilogy(energy_p,'m','LineWidth',1.5);
% % plot(err_UB,'-.r','LineWidth',1.5);
% % plot(err_LB,':b','LineWidth',1.5);
% title('no iterations');
% legend('p4','Upper bound','Lower bound')
% ylabel('energy');
% xlabel('# experiment');
% hold off 

end


