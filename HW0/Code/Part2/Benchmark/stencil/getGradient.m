function [ gradient ] = getGradient(im,binvalues, hdl, hdr)

nrows = size(im,1);
ncols = size(im,2);

%imSize = nrows * ncols;

numMasks = size(hdl,1) * size(hdl,2);
% numMasks = 3*8 = 24

numBins = numel(binvalues);

% Initialize cell array with matrices of all 0s
chiSqrDist = cell(1, numMasks);
for i=1:numMasks
    chiSqrDist{i} = zeros(nrows, ncols);
end

%loop over binvalues (and loop over each mask pair)
lastB = -1;
for binIndex=1:numBins
    b = binvalues(binIndex);

    %turn tmp into a binary matrix where 1's indicate the current binvalue
    tmp = im >lastB & im<=b; 
    tmp = single(tmp); %Convert to single for conv2
        
    for i=1:numMasks
        leftMask = hdl{i};
        rightMask = hdr{i};
        %leftMaskTmp = imfilter(tmp, leftMask);
        %rightMaskTmp = imfilter(tmp, rightMask);
        leftMaskTmp = conv2(tmp, leftMask, 'same');  %convolve image with masks
        rightMaskTmp = conv2(tmp, rightMask, 'same');
        
        %Add chi-sqr for every pixel
        chiSqrDist{i} = chiSqrDist{i} + ...
            0.5 .* ( (leftMaskTmp - rightMaskTmp) .^ 2) ./ ...
            (leftMaskTmp + rightMaskTmp + eps);
    end
    lastB = b;
end

% Convert gradient back to 3d matrix
gradient = reshape(cell2mat(chiSqrDist), nrows, ncols, numMasks);
end