function W = getWChenAndKoltunInjective(D1,D2,params)

bChenKoltun=getoptions(params,'bChenKoltun',0.1);
tauChenKoltun = getoptions(params,'tauChenKoltun',0.6);
n = params.n;
k = params.k;
D1_4D = zeros(k,n,k,n);
D2_4D = zeros(k,n,k,n);

for q = 1:k
    for r = 1:n
        for s = 1:k
            for t = 1:n
                D1_4D(q,r,s,t)=D1(q,s);
                D2_4D(q,r,s,t)=D2(r,t);                
            end
        end
    end
end
D1_2D = reshape(D1_4D,[n*k n*k]);
D2_2D = reshape(D2_4D,[n*k n*k]);

differenceMAt_2D = abs(D1_2D-D2_2D);

W = exp(-min(D2_2D,D1_2D)/bChenKoltun) .* min(differenceMAt_2D,tauChenKoltun);

% add scaling as in Chen and koltun (matters only when using extrisic term!)
sigma=0.1;
lambda=20;
sm=0;
for i=1:k
    for j=i+1:k
        sm=sm+mean(mean(exp(-(min(D1(i,j),D2(1:n,1:n))/sigma))));
    end
end

W=W/sm*n*lambda;
end