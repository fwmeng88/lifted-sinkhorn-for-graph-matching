function W = calcWfromDistMats_GW1(D1,D2,params)
params.null = [];
sigma = getoptions(params,'sigma',0.2);

n = size(D2,1);
k = size(D1,1);
W = zeros(k,n,k,n);
for q = 1:k
    for r = 1:n
        for s = 1:k
            for t = 1:n
                %W(i,j,k,l) = D1(i,k)-D2(j,l);
                W(q,r,s,t)=D1(q,s)-D2(r,t);
            end
        end
    end
end
W = reshape(W,[n*k n*k]);

W = abs(W);
end