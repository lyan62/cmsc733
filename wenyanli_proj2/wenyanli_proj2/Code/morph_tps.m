function [morphed_im,fx,fy] = morph_tps(I2, a1_x, ax_x, ay_x, w_x, a1_y,ax_y, ay_y,w_y, pts,pixel_coords1,I1)
%Input : I2: H*W*3 matrix representing th source image
%        a1_x, ax_x, ay_x, w_x: the parameters solved when doing para_tps
%        in the x direction
%        a1_y, ax_y, ay_y, w_y: the parameters solved when doing para_tps
%        in the y direction
%        pts: N*2 matrix each row representing corresponding poin position
%        (x,y) in target image
%        sz: 1*2 vector representing the target image size(Ht,Wt)
%Output: morphed_im: Ht*Wt*3 matrix representing the morphed image
D = pdist2(pts, pixel_coords1,'squaredeuclidean');
K = calculate_U(D);
K(isnan(K)) = 0;
sum_x = transpose(w_x)*K;
sum_y = transpose(w_y)*K;
fx = round(a1_x + ax_x.*pixel_coords1(:,1)+ ay_x.*pixel_coords1(:,2) + transpose(sum_x));
fy = round(a1_y + ax_y.*pixel_coords1(:,1)+ ay_y.*pixel_coords1(:,2) + transpose(sum_y));
f(:,1) = fx;
f(:,2) = fy;

num_pixels = size(pixel_coords1,1);

for i = 1:num_pixels
v1(i,:) = I1(pixel_coords1(i,2),pixel_coords1(i,1),:);
v2(i,:) = I2(fy(i),fx(i),:);
end
weight = mean(mean(v1)./mean(v2));
%% swap
out_img = I1;
for i = 1:num_pixels
    out_img(pixel_coords1(i,2),pixel_coords1(i,1),:) = weight*I2(fy(i),fx(i),:);
end

morphed_im = out_img;
%imshow(morphed_im);
end