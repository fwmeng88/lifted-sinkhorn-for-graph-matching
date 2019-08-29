function [X] = gen_X_perm( n )
%GEN_X_PERM generate a random permutation matrix

x_vec = randperm(n);%permutation vector
X = zeros(n);
for i = 1:n
    X(i,x_vec(i)) = 1; %acvivalent permutation matrix
end

end

