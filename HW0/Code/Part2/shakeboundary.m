%% Benchmarking Tool for Pb-lite
% Code by Nitin J. Sanket (nitinsan@terpmail.umd.edu) and Kiran Y. D. V.
% (kirany@ymd.edu)
% University of Maryland, College Park
% Code adapted from: Brown University's CS143 by James Hays

clc
clear all;close all;

%% Setup all the necessary Paths
addpath(genpath('./Benchmark/'));
testdir='./Benchmark/data/testset/'; 

files = dir(fullfile(testdir, '*.jpg')); %retrieve all the images in testset;
groundtruthdir='./Benchmark/BSDS500/BSDS500/data/groundTruth/test/'; %need this for benchmark

baselinedir1='./Benchmark/data/sobel_baseline/'; %thresholded sobel or canny edge
baselinedir2='./Benchmark/data/canny_baseline/'; %thresholded sobel or canny edge
sobel_pbdir = '../../Images/SobelPb/';
canny_pbdir = '../../Images/CannyPb/';
tmapdir = '../../Images/TextonMap/';%folder store textonmap results
mypbdir='./Benchmark/data/mypb/';   %folder store pb results
if (~exist(mypbdir,'dir')) mkdir(mypbdir); end


%% Get Sobel baseline
close all;

sobel_pbs=cell(1,length(files));
thresh=.08:.02:.3;
for f=1:length(files)
    fprintf('computing sobel baseline edges #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    im=rgb2gray(im2double(imread(fullfile(testdir,files(f).name))));
    pb=sobel_pb(im,thresh);
    figure(1);imshow(pb);
    imwrite(pb,[baselinedir1,a,'.png'],'png'); 
    imwrite(pb,[sobel_pbdir,['SobelPb_',a,'.png']],'png');
    sobel_pbs{f}=pb;
end


%% Get Canny baseline
close all;

canny_pbs=cell(1,length(files));
thresh=.1:.1:.7;
sigma=1:1:4;
for f=1:length(files)
    fprintf('computing canny baseline edges #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    im=rgb2gray(im2double(imread(fullfile(testdir,files(f).name))));
    pb=canny_pb(im,thresh,sigma);
    figure(1);imshow(pb);
    imwrite(pb,[baselinedir2,a,'.png'],'png'); 
    imwrite(pb,[canny_pbdir,['CannyPb_',a,'.png']],'png');
    canny_pbs{f}=pb;
end



%% Generate Gaussian filterbank

close all;
fb_norient=16;                            %num of orientations for the filter bank
fb_sigmas = [1,2];
theta =1:20:320; 
fb = filterBank(fb_sigmas,theta);
showFilterBank(fb);

set(gcf, 'Position', [0 0 1500 180])
saveas(gcf,'GaussianFB.png');
close all;
%% Generate LM filterbank
s = [sqrt(2), 2, 2*sqrt(2), 4];
ssize = round(6.*s + 1,2);
thetalm =1:60:360; 
LM = LMfilterBank(s,thetalm);
for j = 1:4
    for i  = 1:12
        subplot(4, 12, (j-1)*12 + i);
        imagesc(LM{j,i});
        colormap(gray);
    end
end

set(gcf, 'Position', [0 0 900 400])
saveas(gcf,'LMFB.png');

close all;
%% Genereate S filterbank
sup = 49;
num_filters = 13;
S = SfilterBank(sup);
%plot s filterbank
for j = 1:2
for i = 1:ceil(num_filters/2)
if (j-1)*ceil(num_filters/2)+i < 14
subplot(2, ceil(num_filters/2), (j-1)*ceil(num_filters/2)+i);
imagesc(S{(j-1)*ceil(num_filters/2)+i});
colormap(gray);
end
end
end
saveas(gcf,'SFB.png');

close all;

%% Generate MR filterbank
sigx = [1 2 4];
thetamr = 1:30:180;
sigma = 10;
MR = MRfilterBank(sigma,sigx,thetamr);
for i  = 1:38
subplot(8, 6,i);
imagesc(MR{i});
colormap(gray);
end

saveas(gcf,'MRFB.png');

fb_norient = 16;
theta =1:20:320; 

close all;

%% Generate half-disc masks 
fb_norient = 16;
theta =1:20:320; 

d_orientations=theta(1:fb_norient/2);      
d_size=[3,10,20];                           

[hdl, hdr] = halfDisk(d_size, d_orientations); %generate left and right masks

for j = 1:numel(d_size)
    for f  = 1: numel(d_orientations)
        index = numel(d_orientations)*2*(j-1) + f*2 -1;
    subplot(numel(d_size)*2,numel(d_orientations),index);
    imagesc(hdl{j,f});
    colormap(gray);
    subplot(numel(d_size)*2,numel(d_orientations),index+1);
    imagesc(hdr{j,f});
    colormap(gray);
    end
end                                            %plot the half-disc masks
saveas(gcf,'HDMasks.png');

close all;

%% Generate tmaps
k=64;  % number of clusters
tmaps=cell(1,length(files));
for f=1:length(files)
    fprintf('computing textonmap #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    im=im2double(imread(fullfile(testdir,files(f).name)));
    tmaps{f}= create_tmap(im,k);    %uncomment when using first derivative gaussian filter
    %tmaps{f} = create_tmapLM(im,k);   %uncomment when using LM filterbank
    %tmaps{f} = create_tmapS(im,k);   %uncomment when using S filterbank
    %tmaps{f} = create_tmapMR(im,k);  % uncomment when using MR filterbank
    saveas(gcf,[tmapdir,['TextonMap_',a]],'png');
end
close all;
%% Get tg

tg = cell(1,length(files));
tgdir = '../../Images/tg/';
for f = 1:length(files)
    fprintf('computing tg #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    tg{f} = getGradient(tmaps{f},1:64,hdl,hdr);
    for i = 1:size(tg{f},3)
    subplot(8,3, i);
    imagesc(tg{f}(:,:,i));
    end
    set(gcf, 'Position', [0 0 500 2000])
    saveas(gcf,[tgdir,['tg_',a]],'png');
end
    
close all;
%% Get brightness map
bmapdir = '../../Images/BrightnessMap/';
L = cell(1,length(files));
for f = 1:length(files)
    fprintf('computing brightness map #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    im=im2double(imread(fullfile(testdir,files(f).name)));
    cform = makecform('srgb2lab');
    lab_o = applycform(im,cform);
    L{f}= double(lab_o(:,:,1)); 
    imagesc(L{f});
    saveas(gcf,[bmapdir,['BrightnessMap_',a]],'png');
end

close all;
%% Get bg
bgdir = '../../Images/bg/';
bg = cell(1, length(files));
for f = 1:length(files)
    fprintf('computing bg #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    im=im2double(imread(fullfile(testdir,files(f).name)));
    bg{f} = getBG(im,[0:8:255,256],hdl,hdr);
    
    for i = 1:size(bg{f},3)
    subplot(8,3, i);
    imagesc(bg{f}(:,:,i));
    end
    set(gcf, 'Position', [0 0 500 2000])
    saveas(gcf,[bgdir,['bg_',a]],'png');
end
close all;

%% Get cg
cg = cell(1, length(files));
for f = 1:length(files)
    fprintf('computing cg #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    im=im2double(imread(fullfile(testdir,files(f).name)));
    cg{f} = getCG(im,[0:8:255,256],hdl,hdr);
    
    %for i = 1:size(cg{f},3)
    %subplot(8,3, i);
    %imagesc(bg{f}(:,:,i));
    %end
    %set(gcf, 'Position', [0 0 500 2000])
    %saveas(gcf,[bgdir,['bg_',a]],'png');
end
close all;
%% Output PbLite
pblitedir = '../../Images/PbLite/';
PbLite = cell(1,length(files));
g = cell(1,length(files));
for f = 1:length(files)
    fprintf('computing PbLite #%d out of %d\n',f,length(files));
    [a b]=strtok(files(f).name,'.');
    %[mtg I] = max(tg{f},[],3);
    %[mbg I] = max(bg{f},[],3);
    %[mcg I] = max(cg{f},[],3);
    g{f} = 1.5.*tg{f} + bg{f} + cg{f};  %get the maximum
    [mg I] = max(g{f},[],3);
    %pb = (mtg+mbg+mcg).*(0.5.*sobel_pbs{f} + 0.5.*canny_pbs{f});
    pb = mg.*(0.5.*sobel_pbs{f} + 0.5.*canny_pbs{f});
    imwrite(pb,[mypbdir,a,'.png'],'png');   %save for further evaluation use
    imshow(pb);
    saveas(gcf,[pblitedir,['PbLite_',a]],'png');  %save in to Images folder
    PbLite{f} = pb;
    %imagesc(PbLite{f});
    %colormap(gray);
    %saveas(gcf,[mypbdir,a],'png');
end
close all;

%% Evaluation against human
%get results from baseline 1
%run only when the baseline 1 images change

baseline1tmpdir = './Benchmark/data/baseline1tmp/';
if (~exist(baseline1tmpdir,'dir')) mkdir(baseline1tmpdir); end
nthresh =10;
tic;
boundaryBench(testdir, groundtruthdir, baselinedir1, baseline1tmpdir,nthresh);
toc;


%%
%get results from baseline 2
%run only when the baseline 2 images change
baseline2tmpdir = '.Benchmark/data/baseline2tmp/';
if (~exist(baseline2tmpdir,'dir')) mkdir(baseline2tmpdir); end
nthresh =10;
tic;
boundaryBench(testdir, groundtruthdir, baselinedir2, baseline2tmpdir, nthresh);
toc;

%% Get results for pb
mypbtmpdir = '.Benchmark/data/mypbtmp/';
if (~exist(mypbtmpdir,'dir')) mkdir(mypbtmpdir); end
nthresh =10;
tic;
boundaryBench(testdir, groundtruthdir, mypbdir, mypbtmpdir, nthresh);
toc;

%% Plot the PR Curve
dirs = {};
dirs{1}=baseline1tmpdir;
dirs{2}=baseline2tmpdir;
dirs{3}=mypbtmpdir;
colors={'g','m','k'};

%number of names should be 4+number of dirs
%these will appear in the legend of the plot
%the first four are precomputed and not evaluated on the fly
names={'human','contours','canny','gpb','baseline1(sobel)','baseline2(canny)', 'pb-lite'};
plot_eval_multidir(dirs,colors,names);
saveas(gcf,'PR_curve2.png');



%note the dotted lines are copied from figure 17 in the 2011 PAMI paper
%they are tuned/optimized to perform well than the baselines 
%given in the above code.
