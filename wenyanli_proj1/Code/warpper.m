%Imfolder = 'CustomSet1';
%Imfiles = {'1.jpg','2.jpg','3.jpg','4.jpg'} ;
function warpper(Imfolder,Imfiles)
%input: a list of image file names in a format as{'1.jpg','2.jpg','3.jpg','4.jpg'} 
addpath(genpath('../Images/'));
addpath(genpath('../Code/'));
testdir = ['../Images/', Imfolder,'/'];
%testdir = './Images/TestSet2/';
%imgdir = '../savedimages/';
files = fullfile(testdir, Imfiles);
%files = dir(fullfile(testdir, '*.jpg'));
x = cell(1,length(files));
y = cell(1,length(files));
rmax = cell(1,length(files));

%collect imgs
imcollect = cell(1,length(files));
for f = 1:length(files)
    %[a b]=strtok(files(f).name,'.');
    [a b]=strtok(Imfiles{f},'.');
%im=im2double(imread(fullfile(testdir,files(f).name)));
im=im2double(imread(files{f}));
imcollect{f} = im;

N_best = 300;
[x{f}, y{f}, rmax{f}] = anms(imcollect{f},N_best); % get coordinates for best corners

% feature descriptors
[p{f}] = feat_desc(imcollect{f},y{f},x{f},N_best); % get feature descriptors for corners

%set(gca,'position',[0 0 1 1],'units','normalized')
%saveas(gcf,[imgdir,['anms_',a]],'png');

%save image:
%z=getframe; 
%imwrite(z.cdata,[imgdir,['anms_',Imfolder,'_',a,'.png']],'png'); 
% save images into directory

end

%%
close all;


for f = 1:length(files)
    %[a b]=strtok(files(f).name,'.');
    [a(f) b]=strtok(Imfiles{f},'.');
end

l = length(files);
    if mod(l,2) == 1
        ref = (l+1)/2%set the middle img as reference
    else
        ref = l/2
    end
        for i  = 1: (ref-1)
            pind1(i) = i;
            pind2(i) = i+1;
        end
        for j = l:-1:(ref+1)
            pind1(j) = j;
            pind2(j) = j-1;
        end
    pind1 = pind1(pind1~= 0);
    pind2 = pind2(pind2~= 0);
        
num_pairs = size(pind1,2);
hImage = cell(1,num_pairs);
rehImage = cell(1,num_pairs);
inlinears = cell(1,num_pairs);
pair_matchedpts1 = cell(1,num_pairs);
pair_matchedpts2 = cell(1,num_pairs);
iters = 100;
for np = 1:num_pairs
    [pair_matchedpts1{np}, pair_matchedpts2{np}] = feature_match(p,pind1(np),pind2(np),x,y);
    [hImage{np}] = dispMatchedFeatures(imcollect{pind1(np)},imcollect{pind2(np)},pair_matchedpts1{np},pair_matchedpts2{np},'montage');
    [inlinears{np}, finalH{np}] = iter(pair_matchedpts1{np}, pair_matchedpts2{np},iters,0.65);
    [rehImage{np}] = redisp(inlinears{np},imcollect{pind1(np)},imcollect{pind2(np)},pair_matchedpts1{np},pair_matchedpts2{np});
    %z=getframe; 
    %imwrite(z.cdata,[imgdir,['feature_matching_',Imfolder,'_',a(np),'.png']],'png'); 
end
    
close all;

%% Cylinder projection
for f = 1:length(files)
    imcylind{f} = cylind(imcollect{f});
    figure, imshow(imcylind{f})
    %z=getframe; 
    %imwrite(z.cdata,[imgdir,['Cylind_',Imfolder,'_',a(f),'.png']],'png'); 
end
close all;
%%
imref = imcylind{ref};
imsize = size(imref);
tform = cell(1,l);
for np = 1:(ref-1)
tform{np} = projective2d(transpose(finalH{np}));
end
tform{ref} = projective2d(eye(3));
for np = ref:num_pairs
tform{np+1} = projective2d(transpose(finalH{np}));
end

Tinv = invert(tform{ref});
for i  =  1:numel(tform)
    tform{i}.T = Tinv.T * tform{i}.T;
end
%%
imageSize = size(imcylind{ref});

%compute the output limits for each transform
for i = 1:numel(tform)
    [xlim(i,:), ylim(i,:)] = outputLimits(tform{i}, [1 imageSize(2)], [1 imageSize(1)]);
end
%%3 images(2 pairs when middle img as the center)

xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

width  = round(xMax - xMin);
height = round(yMax - yMin);

panorama = zeros([height width 3], 'like', imcylind{ref});

%blender = vision.AlphaBlender('Operation', 'Binary mask', ...
   % 'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

%%
%wapedImageleft = cell(1,ref-1);
masks = cell(1,l);
wapedImage = cell(1,l);
for i  = 1:l
        wapedImage{i} = imwarp(imcylind{i},tform{i},'OutputView',panoramaView);
        masks{i}= imwarp(true(imsize(1),imsize(2)), tform{i}, 'OutputView', panoramaView);
        %imshow(wapedImage{i});
        %panorama = step(blender,panorama,wapedImage{i},masks{i});
end

%% stiching using masks
mask = zeros(size(masks{ref},1),size(masks{ref},2));
masksize = size(mask);
for i   = 1:l
    mask = mask+ masks{i};
end
for i  = 1:masksize(1)
    for j = 1:masksize(2)
        if (mask(i,j) ~=0) &(mask(i,j) ~= 1);
            mask(i,j) = 1./mask(i,j);
        end
    end
end

%%
imoutsize = size(wapedImage{ref});
imout= zeros(imoutsize(1),imoutsize(2),3);
for i   = 1:l
    imout = imout+wapedImage{i};
end

imoutr = imout(:,:,1).* mask(:,:);
imoutg = imout(:,:,2).* mask(:,:);
imoutb = imout(:,:,3).* mask(:,:);
imout(:,:,1) =imoutr;
imout(:,:,2) = imoutg;
imout(:,:,3) = imoutb;
imshow(imout);

%z=getframe; 
%imwrite(z.cdata,[imgdir,['panorama_method_1_',Imfolder,'_',a,'.png']],'png'); 
%% stitching method 2
imoutsize = size(wapedImage{ref});
div_ind = floor(imoutsize(2)/l);
for i  = 1:l
    srt = (i-1)*div_ind + 1;
    nd = i*div_ind;
M(:,srt:nd,:) = wapedImage{i}(:,srt:nd,:);
end
figure,imshow(M);
%z=getframe; 
%imwrite(z.cdata,[imgdir,['panorama_method_2_',Imfolder,'.png']],'png'); 
close all;



%% stitching method 3
if f==3
    C = merge(wapedImage{1},wapedImage{2});
    D = merge(wapedImage{3},wapedImage{2});
    Out = merge(C,D);
    imshow(Out);
end
%z=getframe; 
%imwrite(z.cdata,[imgdir,['panorama_method_3_',Imfolder,'.png']],'png'); 
close all;
end



