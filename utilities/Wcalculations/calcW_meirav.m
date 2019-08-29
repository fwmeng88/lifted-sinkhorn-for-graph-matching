function [ O_params] = calcW_meirav(file_path,file_path_GT )
load(file_path);
[n,m] = size(D);
W1 = zeros(m,m,n,n);
N = size(W,1);
x = find(E);
[I,J] = ind2sub([n,n],x);
for k = 1:N
    wi = W(k,:,:);
    i = I(k);
    j = J(k);
    W1(:,:,i,j) = wi;
end
W1 = permute(W1,[3,1,4,2]);
W1 = sparse(reshape(W1,[n*m,n*m]));
Adj = sparse(E ~= 0);

I_GT = imread(file_path_GT);
I_GT = I_GT';
X_GT = image2X(I_GT);
energy_GT = X_GT(:)'*W1*X_GT(:) + sum(D(:).*X_GT(:));

O_params.n = n;
O_params.m = m;
O_params.W = W1;
O_params.Z = D;
O_params.Adj = Adj;
O_params.X_GT = X_GT;
O_params.I_GT = I_GT;
O_params.energy_GT = energy_GT;

end

