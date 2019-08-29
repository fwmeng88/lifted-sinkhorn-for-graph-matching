function [ constraint_dist,bool_output ] = stopping_criteria(X,Y,eps0 )
%STOPPING_CRITERIA - this is used when ||Xn(i,j) - Xn+1(i,j)|| < eps*max{Xn(i,j),b}
%where b is some typical values of X
uno2 = ones(size(X,1),1);
uno1 = ones(size(X,2),1);
mu1 = X*uno1;
mu2 = X'*uno2;
Ysum1 = sum(Y,3);
Xmat1 = repmat(X,[1,1,size(X,1),1]);
Ysum2 = sum(Y,4);
Xmat2 = repmat(X,[1,1,1,size(X,1)]);
Ysum3 = sum(Y,1);
Xmat3 = repmat(X,[1,1,1,size(X,1)]);
Xmat3 = permute(Xmat3,[3,4,1,2]);

m1 = max(abs(1 - mu1));
m2 = max(abs(1 - mu2));
m3 = max(abs(Ysum1(:) - Xmat1(:)));
m4 = max(abs(Ysum2(:) - Xmat2(:)));
m5 = max(abs(Ysum3(:) - Xmat3(:)));

% cond1 = m1 < eps0;
% cond2 = m2 < eps0; 
% cond3 = m3 < eps0;
% cond4 = m4 < eps0;
% cond5 = m5 < eps0;


% % ADD ANOTHER COND FOR THIRD SPACE
constraint_dist = max([m1,m2,m3,m4,m5]);
bool_output = constraint_dist < eps0;%cond1*cond2*cond3*cond4*cond5;


% b = 0.5;
% xi  = abs(Xprev - Xnext);
% stopM = eps0*((Xprev <= b)*b + (Xprev > b).*Xprev);
% bool_output = sum(sum(stopM <= xi)) ~= 0;
% bool_output = ~bool_output;
end

