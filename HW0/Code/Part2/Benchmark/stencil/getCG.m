function CG = getCG(im,binvalues,hdl, hdr)
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
astar = double(lab_o(:,:,2));
bstar = double(lab_o(:,:,3));

numBins = numel(binvalues);


chiSqrDista = cell(1, numMasks);
chiSqrDistb = cell(1, numMasks);
for i=1:numMasks
    chiSqrDista{i} = zeros(nrows, ncols);
    chiSqrDistb{i} = zeros(nrows, ncols);
end


%loop over binvalues (and loop over each mask pair)
lastB = -1;
for binIndex=1:numBins
    b = binvalues(binIndex);

    %turn tmp into a binary matrix where 1's indicate the current binvalue
    tmpa = astar >lastB & astar <=b; 
    tmpa = single(tmpa); %Convert to single for conv2
    tmpb = bstar >lastB & bstar <=b; 
    tmpb = single(tmpb);
        
    for i=1:numMasks
        leftMask = hdl{i};
        rightMask = hdr{i};
        %leftMaskTmp = imfilter(tmp, leftMask);
        %rightMaskTmp = imfilter(tmp, rightMask);
        leftMaskTmpa = conv2(tmpa, leftMask, 'same');
        rightMaskTmpa = conv2(tmpa, rightMask, 'same');
        leftMaskTmpb = conv2(tmpb, leftMask, 'same');
        rightMaskTmpb = conv2(tmpb, rightMask, 'same');
        %Add chi-sqr for every pixel
        chiSqrDista{i} = chiSqrDista{i} + ...
            0.5 .* ( (leftMaskTmpa - rightMaskTmpa) .^ 2) ./ ...
            (leftMaskTmpa + rightMaskTmpa + eps);
        chiSqrDistb{i} = chiSqrDistb{i} + ...
            0.5 .* ( (leftMaskTmpb - rightMaskTmpb) .^ 2) ./ ...
            (leftMaskTmpb + rightMaskTmpb + eps);
    end
    lastB = b;
end
CGa = reshape(cell2mat(chiSqrDista), nrows, ncols, numMasks);
CGb = reshape(cell2mat(chiSqrDistb), nrows, ncols, numMasks);
CG = CGa + CGb;
end