function [ Rs, ts ] = EstimateRt_linear( Hs, K )
% Linear parameter estimation of R and t
%
%   K: a camera calibration matrix. 3 x 3 matrix.
%
%   Hs: a homography from the world to images. 3 x 3 x N matrix, where N is 
%   the number of calibration images. 
%
%   Rs: rotation matrices. 3 x 3 x N matrix, where N is the number of calibration images. 
%
%   ts: translation vectors. 3 x 1 x N matrix, where N is the number of calibration images. 
%

%% Your code goes here.
K_inv = inv(K);
for n = 1:size(Hs,3)
z_prime(n) = norm(K_inv*Hs(:,1,n));
r1(:,:,n) =(1/z_prime(n))*K_inv*Hs(:,1,n);
r2(:,:,n) =(1/z_prime(n))*K_inv*Hs(:,2,n);
r3(:,:,n) = cross(r1(:,:,n),r2(:,:,n));
t(:,:,n)= (1/z_prime(n))*K_inv*Hs(:,3,n);
Rs = [r1 r2 r3];
ts = t;
end

