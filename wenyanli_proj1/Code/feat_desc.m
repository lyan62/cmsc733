%% Feature discriptor
function [p] = feat_desc(im,y,x,N_best)
%input:  im = image retrieved from dataset
%        y =  n*1 vector representing the row coordinates of corners
%        x =  n*1 vector representing the column coordiantes of the corners
%        N_best = number of corners desired
%output: p = cell struct which saves 64*1 feature discriptor for each
%        corner for each image
imgray = rgb2gray(im);
%% 40*40 window around each corner
w = cell(1,N_best);
for i  = 1:N_best
    if y(i) - 20 >0;
        s_y(i) = y(i)-20;
    else s_y(i) = 1;
    end
    if y(i) + 19 < size(im,1)
        e_y(i) = y(i)+19;
    else e_y(i) = size(im,1);
    end
    if x(i)-20>0
        s_x(i) = x(i)-20;
    else s_x(i) = 1;
    end
    
    if x(i) + 19 <size(im,2)
        e_x(i) = x(i) + 19;
    else e_x(i) = size(im,2);
    end
w{i} = imgray(s_y(i):e_y(i),s_x(i):e_x(i));
end

%% blur and sample
h = fspecial('gaussian',2,0.3);
blurred = cell(1,N_best);
for i  = 1:N_best
blurred{i} = imfilter(w{i},h);
end

%down sample
sampled = cell(1,N_best);
for i = 1:300
wsizex = size(blurred{i},1);
wsizey = size(blurred{i},2);
interx = floor(wsizex/8);
intery = floor(wsizey/8);
sampled{i} = blurred{i}(1:interx:interx*8,1:intery:intery*8);
sampled{i} = reshape(sampled{i},[64 1]);
end

%standardize 
standardized = cell(1,N_best);
for i = 1:N_best
standardized{i} = (sampled{i}- mean(sampled{i}))./std(sampled{i});
end
p = standardized;
end