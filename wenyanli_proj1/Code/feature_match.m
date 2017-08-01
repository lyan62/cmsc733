%% descriptor matching
function [matchedpts1, matchedpts2] = feature_match(p,pind1,pind2,x,y)
%input :   p1 = N_best 64*1 vector 
%          p2 = N_best 64*1 vector
%output :  matched1  = confident feature coordinates in image1
%          matched2  = confident feature coordinates in image2
ssd  =  cell(1,300);
sorted_ssd = cell(1,300);
matchindex = cell(1,300);
best_match_ratio = zeros(1,300);
ratio_thresh1 = 0.5;
feature_ind = zeros(1,300);
for i  = 1: 300
    for j = 1:300
    ssd{i}(j) = sum((p{pind1}{i}(:) - p{pind2}{j}(:)).^2);
    end
    [sorted_ssd{i}, matchindex{i}] = sort(ssd{i},'ascend');
    best_match_ratio(i) = sorted_ssd{i}(1)./sorted_ssd{i}(2);    
    if best_match_ratio(i) < ratio_thresh1
        m1(i) = i;
        m2(i) = matchindex{i}(1);
    else
        m1(i) = -1;
        m2(i) = -1;
        i = i+1;
    end
end
matched1 = m1(m1~=-1);
matched2 = m2(m2~=-1);

matchedpts1 = zeros(size(matched1,2),2);
matchedpts2 = zeros(size(matched1,2),2);
for i  = 1:size(matched1,2)
    ind1 = matched1(i);
    ind2 = matched2(i);
    matchedpts1(i,:)= [x{pind1}(ind1),y{pind1}(ind1)];
    matchedpts2(i,:)= [x{pind2}(ind2),y{pind2}(ind2)];
    %matchedpts1(i,:)= [x{2}(ind1),y{2}(ind1)];  %test
    %matchedpts2(i,:)= [x{3}(ind2),y{3}(ind2)];  %test
end
        
end