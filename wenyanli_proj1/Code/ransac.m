%% Ransac
function [inlinears, H] = ransac(matchedpts1, matchedpts2,ratio_thresh)
%input:  matchedpts1 = coordinates of matched points in im1
%        matchedpts2 = coordinates of matched points in im2
%output: H = the 3*3 matrix computed in final step of RANSAC
%        inlinears = n*1 vector with indices of pts in the arrays
%        x1,y1,x2,y2 that were found to be the inlinears
pts_in1 = zeros(4,2);
pts_in2 = zeros(4,2);
rand_ind = randsample(size(matchedpts1,1),4);
for i = 1:4
    pts_in1(i,:) = matchedpts1(rand_ind(i),:);
    p1_X(i) = pts_in1(i,1);
    p1_Y(i) = pts_in1(i,2);
    pts_in2(i,:) = matchedpts2(rand_ind(i),:);
    p2_X(i) = pts_in2(i,1);
    p2_Y(i) = pts_in2(i,2);
end

%% compute H
H = est_homography(p2_X,p2_Y,p1_X,p1_Y); 
%T = fitgeotrans([p2_X,p2_Y],[p1_X,p1_Y],'projective');%source points are points in p1,destination pts in p2

%% apply homography
%ratio_thresh = 0.8;
[Hp1x, Hp1y] = apply_homography(H, matchedpts1(:,1), matchedpts1(:,2)); 
ssd_homo = cell(1,size(matchedpts2,1));
%calculate ssd
for i  = 1: size(matchedpts2,1)
    for j = 1:size(matchedpts2,1)
        ssd_homo{i}(j) = sum((matchedpts2(i,1) - Hp1x(j)).^2 + (matchedpts2(i,2) - Hp1y(j)).^2);
    end
        [sorted_ssd_homo{i}, matchindex_homo{i}] = sort(ssd_homo{i},'ascend');
        homo_match_ratio(i) = sorted_ssd_homo{i}(1)./sorted_ssd_homo{i}(2);    
    if homo_match_ratio(i) < ratio_thresh
        in(i) = i;
        %in2(i) = matchindex{i}(1);
    else
        in(i) = -1;
    end
end

inlinears = in(in~=-1);
if length(inlinears) < 5
    printf('There are too less features to match the images');
end
end
