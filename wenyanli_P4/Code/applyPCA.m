function normal = applyPCA(X)
% input X: [m * n], with m # of variables, n # of samples (m = 3, n = pts in each group)
% input should be group{i}(1:3)';
% output Y:[m * n], matrix with decending order of principal components

rows = size(X,1);
cols = size(X,2);
delta = 1;
% return colmun vector with average of each row
avg = mean(X,2); 
%ensure zero mean across the rows
X  =  X - repmat(avg,1,cols);
% calculate the covariance matrix
CovMatrix = (1/(cols - 1))* X* X';  
if det(CovMatrix) == 0
    CovMatrix = CovMatrix + delta*eye(rows);
end
% using SVD for PCA;
[U Sigma V] = svd(CovMatrix);  
% project original data on to the direction described by the principal
% components
% Y = V'*X; 
% d = - V(:,3)'*avg;
% normal = [V(:,3)' d];
normal = V(:,3)';
end