function [ ] = comper_solvers( params1,params2,no_fig )
%comper_solvers compering two solvers solutions
X1 = params1.X;
Y1 = params1.Y;
obj1 = params1.obj;
X2 = params2.X;
Y2 = params2.Y;
obj2 = params2.obj;

fprintf('HM    solver Got energy=%.4f',obj1);
fprintf('mosek solver Got energy=%.4f',obj2);
fprintf('obj differance =%.4f, X distance = %.4f, Y distance = %.4f '...
    ,obj2-obj1,norm(X2 - X1,'fro'),norm(Y2(:) - Y1(:),'fro'));
figure(no_fig);
subplot(2,1,1);
title('solver 1');
imagesc(X1);
subplot(2,1,2);
title('solver 2');
imagesc(X2);





end

