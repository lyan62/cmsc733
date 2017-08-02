clear;
clc;
im = imread('../Images/Brain.jpg');
gray = rgb2gray(im);
out = ad(gray, 1000, 16, 0.05, 1);
imshow(out);
imagesc(out);
% diff = anisodiff(gray, 50, 20, 0.2, 1);
% imshow(diff);

%% TEST influence of parameter-k
% im = imread('Brain.jpg');
% gray = rgb2gray(im);
% for i  = 1:5:20
%     fprintf('\rwith parameter k equals to %d',i);
%     out = ad(gray, 1000, 20-i, 0.2, 1);
%     subplot(2,2,ceil(i/5));
%     imshow(out);
%     imagesc(out);
% end
% 
% % seems when k < 20 the performance is better. 
% % seems k controls the extent of diffusion
% 
 %% Test influence of parameter - lambda with k =20
% 
% clear all;
% clc ;
% im = imread('Brain.jpg');
% gray = rgb2gray(im);
% for i  = 0.15:0.05:0.25
%     fprintf('\rwith parameter k equals to %d',i);
%     out = ad(gray, 1000, 20, 0.25-i, 1);
%     subplot(1,3,ceil(i/0.05)-2);
%     imshow(out);
%     imagesc(out);
% end