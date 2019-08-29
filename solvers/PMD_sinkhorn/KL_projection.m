function [ Y,X,break_flag ] = KL_projection( W,Z,proj_dim )
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

switch proj_dim
    case 1
        W = permute(W,[1,2,3,4]);
    case 2
        W = permute(W,[2,1,4,3]);
        Z = Z';
    case 3
        W = permute(W,[3,4,1,2]);
    case 4
        Z = Z';
        
        W = permute(W,[4,3,2,1]);
    otherwise
        disp('un cool dog, un cool')
end

break_flag = false;
[n,m] = size(Z);
q = (log(Z) + squeeze(sum(log(sum(W,1)),2))) ...    %formula 18a without the exp (it happen on the next line)
    ./ (m+1);
X = softMax_tzb(q,1);                               %formula 18b preformed in a numericaly stabel way
%%%%%%%%%% error trouble %%%%%%%%%%%%
if ~sum(isnan(X(:))) == 0
    break_flag = true;
    X = Z;
    Y = W;
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumZ = sum(W,1);                                    %sum_i[W_ijkl]
normZ = W./repmat(sumZ,[n,1,1,1]);                  %soft indicator: W_ijkl./sum_i[W_ijkl]
normZ(isnan(normZ)) = 0;                            %DEBUG - IS IT COOL TO CALIM 0/0 = 0 HERE?
x_mat = repmat(X,[1,1,n,m]);
x_mat = permute(x_mat,[3,4,1,2]);
Y = normZ.*x_mat;                                   %formula 18c - v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)

switch proj_dim
    case 1
        Y = permute(Y,[1,2,3,4]);
    case 2
        Y = permute(Y,[2,1,4,3]);
        X = X';
    case 3
        Y = permute(Y,[3,4,1,2]);
    case 4
        Y = permute(Y,[4,3,2,1]);
        X = X';
    otherwise
        disp('not cool dog, not cool')
end
end

