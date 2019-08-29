function [ Max ] = logSumExp_tzb( T,dim )
%LOGSUMEXP Summary of this function goes here
%   Detailed explanation goes here
Size_vector = size(T);
n = Size_vector(dim);
uno = ones(1,length(Size_vector));
V1 = uno;
V1(dim) = n;
maxT = repmat(max(T,[],dim),V1);
maxT2 = max(T,[],dim);
T2 = (T - maxT);
Max = log(sum(exp(T2),dim)) + maxT2;
end
