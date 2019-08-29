function [ Y,X,break_flag ] = KL_projection_fast( W,Z,proj_dim )
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
        %W = permute(W,[1,2,3,4]);
        [X,Y] = KL_proj1(W,Z);
    case 2
        %W = permute(W,[2,1,4,3]);
        %Z = Z';
        [X,Y] = KL_proj2(W,Z);
    case 3
        %W = permute(W,[3,4,1,2]);
        [X,Y] = KL_proj3(W,Z);
    case 4
        %Z = Z';
        %W = permute(W,[4,3,2,1]);
        [X,Y] = KL_proj4(W,Z);
    otherwise
        disp('un cool dog, un cool')
end
break_flag = false;

end

function [X,Y] = KL_proj1(W,Z)
[n,m] = size(Z);
q = (log(Z) + squeeze(sum(log(sum(W,1)),2))) ...    %formula 18a without the exp (it happen on the next line)
    ./ (m+1);
X = softMax_tzb(q,1);                               %formula 18b preformed in a numericaly stabel way
sumW = sum(W,1);                                    %sum_i[W_ijkl]
normW = W./repmat(sumW,[n,1,1,1]);                  %soft indicator: W_ijkl./sum_i[W_ijkl]
normW(isnan(normW)) = 0;                            %DEBUG - IS IT COOL TO CALIM 0/0 = 0 HERE?
x_mat = repmat(X,[1,1,n,m]);
x_mat = permute(x_mat,[3,4,1,2]);
Y = normW.*x_mat;                                   %formula 18c - v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)
end

function [X,Y] = KL_proj2(W,Z)
[n,m] = size(Z);
q = (log(Z) + squeeze(sum(log(sum(W,2)),1))) ...    %formula 18a without the exp (it happen on the next line)
    ./ (m+1);
X = softMax_tzb(q,2);                               %formula 18b preformed in a numericaly stabel way
sumW = sum(W,2);                                    %sum_i[W_ijkl]
%normW2 = bsxfun(@rdivide,W,sumW);
normW = W./repmat(sumW,[1,m,1,1]);
normW(isnan(normW)) = 0;                            %DEBUG - IS IT COOL TO CALIM 0/0 = 0 HERE?
x_mat = repmat(X,[1,1,m,n]);
x_mat = permute(x_mat,[3,4,1,2]);
Y = normW.*x_mat;                                   %formula 18c - v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)
end

function [X,Y] = KL_proj3(W,Z)
[n,m] = size(Z);
q = (log(Z) + squeeze(sum(log(sum(W,3)),4))) ...    %formula 18a without the exp (it happen on the next line)
    ./ (m+1);
X = softMax_tzb(q,1);                               %formula 18b preformed in a numericaly stabel way
sumW = sum(W,3);                                    %sum_i[W_ijkl]
normW = W./repmat(sumW,[1,1,n,1]);                  %soft indicator: W_ijkl./sum_i[W_ijkl]
normW(isnan(normW)) = 0;                            %DEBUG - IS IT COOL TO CALIM 0/0 = 0 HERE?
x_mat = repmat(X,[1,1,n,m]);
%x_mat = permute(x_mat,[3,4,1,2]);
Y = normW.*x_mat;                                   %formula 18c - v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)
end

function [X,Y] = KL_proj4(W,Z)
[n,m] = size(Z);
q = (log(Z) + squeeze(sum(log(sum(W,4)),3))) ...    %formula 18a without the exp (it happen on the next line)
    ./ (m+1);
X = softMax_tzb(q,2);                               %formula 18b preformed in a numericaly stabel way
sumW = sum(W,4);                                    %sum_i[W_ijkl]
normW = W./repmat(sumW,[1,1,1,n]);                  %soft indicator: W_ijkl./sum_i[W_ijkl]
normW(isnan(normW)) = 0;                            %DEBUG - IS IT COOL TO CALIM 0/0 = 0 HERE?
x_mat = repmat(X,[1,1,n,m]);
%x_mat = permute(x_mat,[3,4,1,2]);
Y = normW.*x_mat;                                   %formula 18c - v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)
end