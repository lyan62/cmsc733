function [class,accuracy,misclassified] = NNEval(tFeatures, tLabels, tstFeatures, tstLabels)
% input: tFeatures: 400 * 59 (for 400 samples)
%        tLables: 400*1 
%        tstFeatures: 200 * 59 (for 200 test samples)
%        tstLables: 200 * 1

num_tst = size(tstFeatures,1);
num_t = size(tFeatures,1);
count = 0;
wrong = 0;
for i  = 1 : num_tst
    for j = 1 : num_t
        diff(j,:) = tFeatures(j,:) - tstFeatures(i,:);
        dist(j) = norm(diff(j,:));
    end
    [M,I] = min(dist);
    class(i) = tLabels(I);
    if class(i) == tstLabels(i)
        count = count + 1;
    else
        wrong = wrong + 1;
        misclassified(wrong) = i;
    end
end

accuracy = count / num_tst;
display(accuracy);
end
