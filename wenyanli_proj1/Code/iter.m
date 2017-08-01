function [inlinears, finalH] = iter(pair1_matchedpts1, pair1_matchedpts2,iters,ratio_threshold)
for iterations  = 1:iters
[inlinears, H] = ransac(pair1_matchedpts1, pair1_matchedpts2,ratio_threshold);
if size(inlinears,2) >= 0.8 * size(pair1_matchedpts1)
    finalH = H;
    finalIns = inlinears;
    break
    
else 
    iterations = iterations +1
    finalH = H;
end
end

%pts_in1 = zeros(4,2);
%pts_in2 = zeros(4,2);
%rand_ind = randsample(size(inlinears,2),4);
%for i = 1:4
%    pts_in1(i,:) = pair1_matchedpts1(rand_ind(i),:);
%    p1_X(i) = pts_in1(i,1);
%    p1_Y(i) = pts_in1(i,2);
%    pts_in2(i,:) = pair1_matchedpts2(rand_ind(i),:);
%    p2_X(i) = pts_in2(i,1);
%    p2_Y(i) = pts_in2(i,2);
%end

%H = est_homography(p2_X,p2_Y,p1_X,p1_Y); 
end