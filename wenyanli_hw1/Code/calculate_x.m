function x_estimate = calculate_x(K,Rs,ts,X)
%x_estimate = zeros(3,1,size(Rs,3));
x_estimate = cell(1,size(Rs,3));
X_homo = zeros(4,1,size(X,1));
for i = 1:size(Rs,3)
    for j = 1:size(X,1)
        X_homo(:,:,j) = transpose([X(j,1) X(j,2) 0 1]); 
        x_estimate{i}(:,:,j) = K*[Rs(:,:,i) ts(:,:,i)]*X_homo(:,:,j);
    end
end

% x_estimate_ij = x_estimate{i}(:,:,j)