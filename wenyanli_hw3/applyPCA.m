function Y = applyPCA(X)
% input X: [m * n], with m # of variables, n # of samples (m = 504, n = 400)
% output Y:[m * n], matrix with decending order of principal components

rows = size(X,1);
cols = size(X,2);
% return colmun vector with average of each row
avg = mean(X,2); 
%ensure zero mean across the rows
X  =  X - repmat(avg,1,cols);
% calculate the covariance matrix
CovMatrix = (1/(cols - 1))* X* X';  
% using SVD for PCA;
[U Sigma V] = svd(CovMatrix);  
% project original data on to the direction described by the principal
% components
Y = V'*X; 

end