function test()
rng(2)
n=50;d=3;
PC1 = rand(n,d);
PC2 = rand(n,d);
dist1 = squareform(pdist(PC1));
dist2 = squareform(pdist(PC2));
frankWolfeSolverRape(-dist1,dist2+eye(n))
frankWolfeSolverRape2(-dist1,dist2+eye(n))


end