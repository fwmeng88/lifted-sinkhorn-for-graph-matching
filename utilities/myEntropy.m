function [ entropy1 ] = myEntropy( X)
%MYENTROPY - calculate entropy in cases were X has actual zeros in it. 
%When there are real zeros, the log(X) calculation will return inf and
%since X is zeros at this points we will have a nan as the multiplication
%Xlog(X). 

XlogX = X(:).*log(X(:));
XlogX(isnan(XlogX)) = 0;
entropy1 = sum((XlogX(:) - X(:)));
end

