function [a1,ax,ay,w] = para_tps(pts, target_val)

pts_num = size(pts, 1);
lambda = 0.001;
P = [pts, ones(pts_num,1)];
D = pdist2(pts, pts,'squaredeuclidean');

K = calculate_U(D);
K(isnan(K)) = 0;
A = [K P; transpose(P) zeros(3)];
v = [target_val; zeros(3,1)];

coef = (A + lambda * eye(pts_num + 3))\v;
w    = coef(1:pts_num);
ax   = coef(pts_num+1);
ay   = coef(pts_num+2);
a1   = coef(pts_num+3);
end