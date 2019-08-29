t = 0:0.001:2;
figure(1);
close
figure(1);
for alpha = [2,1,0.7,0.3,0.1,0.01]
    entropy = alpha*(t.*log(t) - t);
    plot(t,entropy,'LineWidth',2);
    hold on;
end
legend('ent = 2','ent = 1','ent = 0.7','ent = 0.3','ent = 0.1','ent = 0.01')
ylim([-2,1])
hold off
