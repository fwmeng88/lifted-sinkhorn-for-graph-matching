function [ I ] = X2image( X,S )
%CHINESE_POSTPROCESS turns an a signment matrix X in to an image;
I_vec  = X(:,2);
I = reshape(I_vec,S);
end

