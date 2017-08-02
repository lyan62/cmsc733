%%
clear all;
close all;
clc;
% if don't want to go over again and use saved data, just run>>>
% load 'pcaresults.mat'
% num = 153;  % use num to adjust dimensions 
% projected_t = projected(1:num_tfeatures,1:num);
% projected_tst = projected(num_tfeatures + 1:end,1:num);
% [class,accuracy,misclassified] = NNEval(projected_t, tLabels, projected_tst, tstLabels);
%%
% retrieve all the training images from files (run when in the '/image/')
for i = 1:40
    str = strcat('s',int2str(i));
    traindir=strcat('../Images/Dataset/Train/',str); 
    train_files = dir(fullfile(traindir,'*.pgm')); %retrieve all the images in trainset;
    for f=1:length(train_files)
        train_img{(i-1)*length(train_files)+f} = im2double(imread(fullfile(traindir,train_files(f).name)));
        tLabels((i-1)*length(train_files)+f,1) = i;
    end
end
    
%% 
% retrieve all the test images from files
for i = 1:40
    str = strcat('s',int2str(i));
    testdir=strcat('../Images/Dataset/Test/',str); 
    test_files = dir(fullfile(testdir,'*.pgm')); %retrieve all the images in trainset;
    for f=1:length(test_files)
        test_img{(i-1)*length(test_files)+f} = im2double(imread(fullfile(testdir,test_files(f).name)));
        tstLabels((i-1)*length(test_files)+f,1) = i;
    end
end
%%
s = size(train_img{1},1)*size(train_img{1},2);
for i  = 1: length(train_img)
    % trainning set: 160 faces
    % testing set: 240 faces
    tFeatures(i,:) = reshape(train_img{i},1,s);  
end
for i  = 1: length(test_img)
    % trainning set: 160 faces
    % testing set: 240 faces
    tstFeatures(i,:) = reshape(test_img{i},1,s);  
end
%% test results using eigen faces and NN
% [class,accuracy] = PCA_KNN(1,100,tFeatures,tstFeatures,tLabels, tstLabels); 
[class,accuracy] = PCA_NN(200,tFeatures,tstFeatures,tLabels, tstLabels); 

%% training set accuracy 
[class,accuracy] = NNEval(projected_t, tLabels, projected_t, tLabels);
%accuracy: 1
%% separate PCA and evaluation
% [projected_t projected_tst] = reduceDim(100,tFeatures,tstFeatures); %reduce dimension into 100
% [class,accuracy] = NNEval(projected_t, tLabels, projected_tst, tstLabels);
%% classify with bayes
% [class,accuracy] = bayesEval(projected_t, tLabels, projected_tst, tstLabels);
%% use the following two lines to change number of dimensions

% load 'pcaresults.mat'
% num = 200
% projected_t = projected(1:num_tfeatures,1:num);
% projected_tst = projected(num_tfeatures + 1:end,1:num);
% [class,accuracy] = NNEval(projected_t, tLabels, projected_tst, tstLabels);
% dimension = 100 accuracy : 0.8875,
% dimension = 200 accuracy: 0.8971, 
% dimension = 300 accuracy: 0.8833,



%% Test dimension influence
% clear all;
% clc;
% load 'pcaresults.mat'
% for num = 1:1000 % use num to adjust dimensions 
% projected_t = projected(1:num_tfeatures,1:num);
% projected_tst = projected(num_tfeatures + 1:end,1:num);
% [class,accuracy(num)] = NNEval(projected_t, tLabels, projected_tst, tstLabels);
% end
