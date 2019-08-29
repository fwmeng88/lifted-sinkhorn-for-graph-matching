function [ Y,X,break_flag ] = KL_projection_sparse( W,Z,proj_dim,params )
%KL_PROJECTION_FIRST solve 
%min_{X,Y} KL(Y|v) + KL(X|u)
%s.t.      sum_p(Xij) = 1
%          sum_p(Y_ijkl) = X_kl
%were p is in {i, j, k, l} according to PROJ_DIM (a number between 1 and 4)
%--------------------------------------------------------------------------
%INPUT
%   Z - matrix n x m, enrgy argument of the unary term
%   W - tenzor n x m x n x m enrgy argument of the binary term (not neseccerly exists)
%   proj_dim int, represent p
%--------------------------------------------------------------------------
%OUTPUT
%   X - matrix n x m, argminX of the above term
%   Y - tenzor n x m x n x m, argminY of the above term
%--------------------------------------------------------------------------
v_Wadj = params.v_Wadj; %linear inde
switch proj_dim
    case 1
        error('this is sparse implementation, only for mrfs, like single sided so no case 1')
    case 2
        Adj_norm = params.Adj_norm1;
        Z = Z';
    case 3
        error('this is sparse implementation, only for mrfs, like single sided so no case 3')
    case 4
        W = W';
        Adj_norm = params.Adj_norm2';
        Z = Z';
    otherwise
        disp('un cool dog, un cool')
end

break_flag = false;
[n,m] = size(Z);
W1 = 0;

for i = 1:n                                 %step1 - sum W 
W1 = W1 + W(((i-1)*m + 1):(i*m) , :); 
end
logW1 = spfun(@log,W1);                     %step2 - take it's log
q1 = reshape(sum(logW1),[m,n])';            %step3 - fold in to q    
q = (log(Z) + q1) ./ (Adj_norm + 1);
X = softMax_tzb(q,1);                       %formula 18b preformed in a numericaly stabel way

% some DEBUGING shit I need to get read of
if ~sum(isnan(X(:))) == 0
    break_flag = true;
    X = Z';
    switch proj_dim
        case 2
            Y = W;
        case 4
            Y = W';
    end
    return;
end

for i = 1:n                                   %step5 - 
    sumZ(((i-1)*m + 1):(i*m),:) = W1;
end

divi = @(p) 1./p;                             %step6 -
i_sumZ = spfun(divi,sumZ);    
normZ = W.*i_sumZ;

X_tps = X';                                   %step7 - this is the compact aquivalent to the matrix X'(:)*1^T 
X_tps = X_tps(:);
[~,k] = ind2sub([n*m,n*m],v_Wadj);
x_mat1 = X_tps(k);

Y = normZ;                                    %step8 - formula 18c - v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)
Y(v_Wadj) = normZ(v_Wadj).*x_mat1;
switch proj_dim
    case 1
        error('this is sparse implementation, only for mrfs, like single sided so no case 1')
    case 2
%         Y = Y;
        X = X';
    case 3
        error('this is sparse implementation, only for mrfs, like single sided so no case 3')
    case 4
        Y = Y';
        X = X';
    otherwise
        disp('not cool dog, not cool')
end
end

