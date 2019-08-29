function [ u,v ] = y_projection_v7( z,w,d,ind_v,ind_u,params )
% preform a Projection onto an affine set C(ind_v,ind_u) in the KLd sence.
% in an explicite manner it solves to folowing problem - 
% argmin_[u,v] KL(u|w) + KL(v|z)
% s.t. sum_(ind_v) v(i,j,k,l) = u(k,l);
%      sum_(ind_u) u(i,j) = 1

a = params.entropy;
b = params.entropy;
n = params.n;

switch ind_v
    case 1
        z = permute(z,[1,2,3,4]);
    case 2
        z = permute(z,[2,1,4,3]);
        w = w';
    case 3
        z = permute(z,[3,4,1,2]);
    case 4
        w = w';
        z = permute(z,[4,3,2,1]);
    otherwise
        disp('un cool dog, un cool')
end


% q = exp(...
%     a*log(w)./(b*n + a) + ....
%     b*squeeze(sum(log(sum(z,1)),2))./(b*n + a)...
%     );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q = a*log(w)./(b*n + a) + ...
    b*squeeze(sum(log(sum(z,1)),2))./(b*n + a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert(sum(isinf(q(:))) == 0,'q has inf in it');
assert(sum(isnan(q(:))) == 0,'q has nan in it');

% u = q./repmat(sum(q,1),[n,1])*d;
u = softMax_tzb(q,1);
sumZ = sum(z,1);                        %sum_i[z(ijkl)]
normZ = z./repmat(sumZ,[n,1,1,1]);      %z(ijkl)./sum_i[z(ijkl)]
u_mat = repmat(u,[1,1,n,n]);
u_mat = permute(u_mat,[3,4,1,2]);
v = normZ.*u_mat;                       %v(ijkl) = z(ijkl)./sum_i[z(ijkl]*u(k,l)

assert(sum(isinf(v(:))) == 0,'q has inf in it');
assert(sum(isnan(v(:))) == 0,'q has nan in it');

switch ind_v
    case 1
        v = permute(v,[1,2,3,4]);
    case 2
        v = permute(v,[2,1,4,3]);
        u = u';
    case 3
        v = permute(v,[3,4,1,2]);
    case 4
        v = permute(v,[4,3,2,1]);
        u = u';
    otherwise
        disp('not cool dog, not cool')
end

end

