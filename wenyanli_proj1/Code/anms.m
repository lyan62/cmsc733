%% ANMS
function [x y rmax] = anms(im, N_best) 
%input :  im  = the input image from data set, but what we really use is
%the corner strength map(denoted as strongc in the following)
%         N_best  =  the number of corners desired

%output:  x,y  = the coordinates of corners
%         rmax  = suppression radius used to get max_pts corners
imgray = rgb2gray(im);
corn_metr = cornermetric(imgray);
%corn_ad = imadjust(corn_metr);
%strongc = imregionalmax(corn_ad,8);  %try imadjust
strongc  = imregionalmax(corn_metr,8);
%%
%find x,y coordinates of all local maxima
index = 0; %initialize index
for i = 1:size(strongc,1)
for j = 1:size(strongc,2)
if strongc(i,j) ==1,
index = index+1;
y_strong(index) = i; %y coordinates
x_strong(index) = j; %x coordinate
end
end
end

%%
r = inf(1,index);
ed = 0;
for i = 1:index
for j = 1:index
if corn_metr(y_strong(j),x_strong(j)) > corn_metr(y_strong(i),x_strong(i))
ed = (x_strong(j) - x_strong(i))^2 + (y_strong(j) - y_strong(i))^2;
end
if ed < r(i)
r(i) = ed;
end
end
end

%% 
%N_best = 300;
[r_best, I] = sort(r,'descend');

figure,
imshow(im);
hold on;
for i  = 1:N_best
    x(i) = x_strong(I(i));
    y(i) = y_strong(I(i));
    %plot(x_strong(I(i)),y_strong(I(i)),'r.');
    plot(x(i),y(i),'r.');
end

rmax = r_best(1:N_best);
hold off;
end