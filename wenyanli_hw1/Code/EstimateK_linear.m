function [K, Hs] = EstimateK_linear(x, X)
% Linear parameter estimation of K
%
%   x:  2D points. n x 2 x N matrix, where n is the number of corners in
%   a checkerboard and N is the number of calibration images
%       
%   X:  3D points. n x 2 matrix, where n is the number of corners in a
%   checkerboard and assumes the points are on the Z=0 plane
%
%   imgs: calibration images. N x 1 cell, where N is the number of calibration images
%
%   K: a camera calibration matrix. 3 x 3 matrix.
%
%   Hs: a homography from the world to images. 3 x 3 x N matrix, where N is 
%   the number of calibration images. You can use est_homography.m to
%   estimate homographies.
%

%% Your code goes here
num_im = size(x,3);
X_x(:) = X(:,1);
X_y(:) = X(:,2);
x_x(:,:) = x(:,1,:);
x_y(:,:) = x(:,2,:);

for n = 1:num_im
    Hs(:,:,n) = est_homography(x_x(:,n),x_y(:,n),X_x(:),X_y(:));
end

for n = 1:num_im
    v11 = calculate_v(1,1,num_im,Hs);
    v22 = calculate_v(2,2,num_im,Hs);
    v12 = calculate_v(1,2,num_im,Hs);
    v1_2{n}= v11{n}-v22{n};
    V0{n} = [v12{n};v1_2{n}];
end
V = cat(1,V0{1:num_im});
%%
%[val,D] = eig(transpose(V)*V);
%Dv = D(D~=0);
%[SmallD, I] = sort(Dv);

%%
[P S Q] = svd(V);
b = Q(:,end);

py = (b(2)*b(4) - b(1)*b(5))/(b(1)*b(3) - b(2)*b(2));
c = b(6)-(b(4)*b(4) + py*(b(2)*b(4) - b(1)*b(5)))/b(1);
fy = sqrt(c*b(1)/(b(1)*b(3) - b(2)*b(2)));
fx = sqrt(c/b(1));
s = -b(2)*fx*fx*fy/c;
px = (s*py/fy)-b(4)*fx*fx/c;

K = [fx s px;
    0 fy py;
    0 0 1];
end