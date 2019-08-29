function [ X ] = image2X( I )
%IMAGE2X -(chinese letters) turns an image into an asignment matrix X
I = I>0;%turn its values into logical values
[n,m] = size(I); 
I = reshape(I,[n*m,1]); %reshape matrix in to vector
X = [~I,I]; %build asignment matrix
end

