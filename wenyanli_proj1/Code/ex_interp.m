%% anms

addpath(genpath('./Images/'));
addpath(genpath('./Code/'));
testdir = './Images/TestSet3/';
imgdir = './savedimages/';
files = dir(fullfile(testdir, '*.jpg'));
x = cell(1,length(files));
y = cell(1,length(files));
rmax = cell(1,length(files));

%collect imgs
imcollect = cell(1,3);
for f = 1:length(files)
    [a b]=strtok(files(f).name,'.');
im=im2double(imread(fullfile(testdir,files(f).name)));
imcollect{f} = im;
end

for f = 1:length(files)

N_best = 300;
[x{f}, y{f}, rmax{f}] = anms(imcollect{f},N_best); % get coordinates for best corners

% feature descriptors
[p{f}] = feat_desc(imcollect{f},y{f},x{f},N_best); % get feature descriptors for corners

%set(gca,'position',[0 0 1 1],'units','normalized')
%saveas(gcf,[imgdir,['anms_',a]],'png');

%save image:
%z=getframe; 
%imwrite(z.cdata,[imgdir,['anms1_',a,'.png']],'png'); 
% save images into directory

end

close all;
%% feature matching and ransac
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
end
    
close all;

%% Cylinder projection
for f = 1:length(files)
    imcylind{f} = cylind(imcollect{f});
    figure, imshow(imcylind{f})
end

close all;

%%
imref = imcylind{ref};
imsize = size(imref);
tform = cell(1,num_pairs);
for np = 1:num_pairs
tform{np} = projective2d(transpose(finalH{np}));
end

%%
%bbox = [round(xMin) round(xMax) round(yMin) round(yMax)];
bbox = [-400 1200 -200 700];
imref = vgg_warp_H(imcylind{ref},eye(3),'linear',bbox);
imw1 = cell(1,num_pairs);
imw2 = cell(1,num_pairs);
for np = 1:num_pairs
imw1{np} = vgg_warp_H(imcylind{pind1(np)},finalH{np},'linear',bbox);
imw2{np} = vgg_warp_H(imcylind{pind2(np)},eye(3),'linear',bbox);
figure, imshow(imw1{np});
figure,imshow(imw2{np});
end

mergeout = cell(1,num_pairs);
for np = 1:num_pairs
mergeout{np} = double(max(imw1{np},imw2{np}));
figure,imshow(mergeout{np});
end

%z=getframe; 
%imwrite(z.cdata,[imgdir,['testset3_interp_',a,'.png']],'png'); 
%z=getframe; 
%imwrite(z.cdata,[imgdir,['interp_method_',a,'.png']],'png'); 
close all;