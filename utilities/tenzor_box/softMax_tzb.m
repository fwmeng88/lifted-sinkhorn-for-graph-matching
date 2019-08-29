function [ Tout ] = softMax_tzb( Tin, dim)
%SOFT_MAX_ZT Summary of this function goes here
%   Detailed explanation goes here
Size_vector = size(Tin);
n = Size_vector(dim);
V1 = ones(1,length(Size_vector));
V1(dim) = n; %put n at the index vector

maxT = repmat(max(Tin,[],dim),V1);
expT2 = exp((Tin - maxT));
% isnan(expT2)
sumT2 = sum(expT2,dim);                        %sum_i[z(ijkl)]
Tout = expT2./repmat(sumT2,V1);
end

