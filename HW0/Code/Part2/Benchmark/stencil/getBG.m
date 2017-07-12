function BG = getBG(im,binvalues,hdl, hdr)
%im = rgb2gray(im);
%input must be color image
nrows = size(im,1);
ncols = size(im,2);

%numMasks = 3*8 = 24
numMasks = size(hdl,1) * size(hdl,2);

%transform into Lab 
cform = makecform('srgb2lab');
lab_o = applycform(im,cform);
L = double(lab_o(:,:,1));
%astar = double(lab_o(:,:,2));
%bstar = double(lab_o(:,:,3));

numBins = numel(binvalues);


chiSqrDist = cell(1, numMasks);
for i=1:numMasks
    chiSqrDist{i} = zeros(nrows, ncols);
end


%loop over binvalues (and loop over each mask pair)
lastB = -1;
for binIndex=1:numBins
    b = binvalues(binIndex);

    %turn tmp into a binary matrix where 1's indicate the current binvalue
    tmp = L >lastB & L <=b; 
    tmp = single(tmp); %Convert to single for conv2
        
    for i=1:numMasks
        leftMask = hdl{i};
        rightMask = hdr{i};
        %leftMaskTmp = imfilter(tmp, leftMask);
        %rightMaskTmp = imfilter(tmp, rightMask);
        leftMaskTmp = conv2(tmp, leftMask, 'same');
        rightMaskTmp = conv2(tmp, rightMask, 'same');
        
        %Update chi-sqr 
        chiSqrDist{i} = chiSqrDist{i} + ...
            0.5 .* ( (leftMaskTmp - rightMaskTmp) .^ 2) ./ ...
            (leftMaskTmp + rightMaskTmp + eps);
    end
    lastB = b;
end
BG = reshape(cell2mat(chiSqrDist), nrows, ncols, numMasks);
end