function W = getWChenAndKoltun(D1,D2,params)

n = size(D1,1);

bChenKoltun=getoptions(params,'bChenKoltun',0.1);
tauChenKoltun = getoptions(params,'tauChenKoltun',0.6);
% generate W
% make a matrix with all possiblities of pairs (including degenerate
% ones- same vertrex in the same mesh with a pair in the second mesh
differenceMAt_4D = bsxfun(@minus,D1(:,:),reshape(D2(:,:),[1 1 n n]));
differenceMAt_2D = abs(reshape(permute(differenceMAt_4D,[1 3 2 4]),[n^2 n^2]));
% now output mat holds |d1_ij-d2_kl|;

% create some aux variables
D1_4D = bsxfun(@minus,D1(:,:),zeros(size(reshape(D2(:,:),[1 1 n n]))));
D1_2D = reshape(permute(D1_4D,[1 3 2 4]),[n^2 n^2]);

D2_4D = bsxfun(@minus,D2(:,:),zeros(size(reshape(D1(:,:),[1 1 n n]))));
D2_2D = reshape(permute(D2_4D,[1 3 2 4]),[n^2 n^2]);

W = exp(-min(D2_2D,D1_2D)/bChenKoltun) .* min(differenceMAt_2D,tauChenKoltun);


% add scaling as in Chen and koltun (matters only when using extrisic term!)
sigma=0.1;
lambda=20;
sm=0;
for i=1:n
    for j=i+1:n
        sm=sm+mean(mean(exp(-(min(D1(i,j),D2(1:n,1:n))/sigma))));
    end
end

W=W/sm*n*lambda;
end