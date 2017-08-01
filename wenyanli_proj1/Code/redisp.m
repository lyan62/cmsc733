%% redispMatched features
function hImage = redisp(inlinears,im1,im2,matchedpts1, matchedpts2)
for i = 1:size(inlinears,2)
    pts_in1(i,:) = matchedpts1(inlinears(i),:);
    p1_X(i) = pts_in1(i,1);
    p1_Y(i) = pts_in1(i,2);
    pts_in2(i,:) = matchedpts2(inlinears(i),:);
    p2_X(i) = pts_in2(i,1);
    p2_Y(i) = pts_in2(i,2);
    
    %hImage = dispMatchedFeatures(imcollect{2},imcollect{3},pts_in1,pts_in2,'montage');  %test
end
hImage = dispMatchedFeatures(im1,im2,pts_in1,pts_in2,'montage');
end