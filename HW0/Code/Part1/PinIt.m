% load image
I = imread('TestImgResized.jpg');
figure,
imshow(I);
im = rgb2gray(I);

%%
%%%denoise using gaussian filter
%sigma = 1.5;
%w = sigma * 6 + 1;
%G = fspecial('gaussian',w, sigma);
G = gaussianMatrix(31);
o = imfilter(I,G,'replicate');

%plot
figure;
subplot(1,2,1);
imagesc(I);
title('the original image');
subplot(1,2,2);
imagesc(o);
title('the image after gaussian smoothing');

%%
hsv_o = rgb2hsv(o);
hsv2 = hsv_o(:,:,2);

se = strel('sphere',10);
dilated = imdilate(hsv2,se);
%imshow(dilated);

[centers, rads] = imfindcircles(dilated,[23,40]);
count = numel(centers)/2;
figure,imshow(I);
hold on;
viscircles(centers,rads);
title([num2str(count) ' colored pins found!']);
hold off;

%%
%%%color-based segmentation using k-means clustering
cform = makecform('srgb2lab');
lab_o = applycform(o,cform);

ab = double(lab_o(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 5;
%repeat the clustering 5 times to avoid local minima
[cluster_idx,cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean',...
    'Replicates',5);

pixel_labels = reshape(cluster_idx,nrows,ncols);
figure,imshow(pixel_labels,[]),title('image labeled by cluster index');

%create images that segment the image by color
segmented_images = cell(1,5);
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    color = o;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

%figure,
%subplot(2,3,1);imshow(I),title('the original image');
%subplot(2,3,2);imshow(segmented_images{1}),title('objects in color 1');
%subplot(2,3,3);imshow(segmented_images{2}),title('objects in color 2');
%subplot(2,3,4);imshow(segmented_images{3}),title('objects in color 3');
%subplot(2,3,5);imshow(segmented_images{4}),title('objects in color 4');
%subplot(2,3,6);imshow(segmented_images{5}),title('objects in color 5');

%%
segs = cell(1,5);
se2 = strel('sphere',12);
figure,
subplot(2,3,1);imshow(I),title('the original image');
%subplot(2,3,2);imshow(segmented_images{1}),title('objects in color 1');
for i  = 1:5
segs{i} = rgb2hsv(segmented_images{i});
dilated2 = imdilate(segs{i}(:,:,2),se2);
[cs, rs] = imfindcircles(dilated2,[10,40]);
cnt = numel(cs)/2;

if cnt > 10,
    ims = segmented_images{i};
    i = i+1;
    j = i;
end
subplot(2,3,i+1);
imshow(segmented_images{i});
hold on;
viscircles(cs,rs);
title([num2str(cnt) ' objects in this color!']);
hold off;
end

saveas(gcf, 'IndividualColoredObjects.png');

%% find the white pin
close all;
M = repmat(all(~ims,3),[1 1 3]); %mask black parts
ims(M) = 164; %turn them gray-white
imo = imfilter(ims,G);
imohsv = rgb2hsv(imo);   %convert into hsv color space
imohsv_sat = imohsv(:,:,2);

hsv_dilated = imdilate(imohsv_sat,se);
[whitec,whiter] = imfindcircles(hsv_dilated,[10,15]);
figure, imshow(I);
hold on
viscircles(whitec,whiter);
title('white pin detected!');
saveas(gcf,'whitepin.png');











