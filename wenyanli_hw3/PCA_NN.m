function [class,accuracy] = PCA_NN(num,tFeatures,tstFeatures,tLabels, tstLabels)
% input     k: # of neighbors
%         num: reduced dimensions/ # of principal components
%   tFeatures: trainning features [400*504]
% tstFeatures: test features      [200*504]
%      tLabels: 400*1
%      tstLabels: 200*1
features = [tFeatures; tstFeatures]; %[600 * 504]
features = features'; % need [m*n] for applyPCA
projected = applyPCA(features); %  Y = [504*600]
projected = projected'; %[600 * 504]
num_tfeatures= size(tFeatures,1);
% reduce dimension to num(use first (num) principal components)
projected_t = projected(1:num_tfeatures,1:num);
projected_tst = projected(num_tfeatures + 1:end,1:num);
[class,accuracy] = NNEval(projected_t, tLabels, projected_tst, tstLabels);
end