function W = calcWfromDistMats_ISO(D1,D2,params)
params.null = [];
n = size(D1,1);
sigma = getoptions(params,'sigma',0.2);
% generate W
% make a matrix with all possiblities of pairs (including degenerate
% ones- same vertrex in the same mesh with a pair in the second mesh
outputMat_4D = bsxfun(@minus,D1(:,:),reshape(D2(:,:),[1 1 n n]));
outputMat = reshape(permute(outputMat_4D,[1 3 2 4]),[n^2 n^2]);
% get the std of d_i - d_j, I use the same outputMat due to memory
% efficiency, when sigma is big, trust not that accurate distances
% diffrences to be
% change nan into inf, it would be 0 evantually
outputMat(isnan(outputMat)) = inf;
distAvgSigma = sigma;%*std2(outputMat(outputMat ~= inf & outputMat ~= -inf));
% -e^{-(d_i-dj)^2/ (c*sigma)^2}
W = -exp(-(outputMat .^ 2) / distAvgSigma^2);

end