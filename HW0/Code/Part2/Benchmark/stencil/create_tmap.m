function tmap = create_tmap(im)
%%
%sanity check
if size(im,3) > 1
    im = rgb2gray(im);
end

if ~isfloat(im)
    im = im2double(im);
end

nrows = size(im,1);
ncols = size(im,2);
%make filterbank
s = [0.5 1];
theta = 1:20:320;
fb = filterBank(s,theta);
numFilters = numel(s)*numel(theta);
res = cell(1, numFilters);   %res is a 1*32 cell;


%compute the response after convolutions with filters
for i = 1:numFilters,
    index1 = ceil(i/16);
    index2 = mod(i,16);
    if index2 == 0,
        index2 = 16;
    end
    res{i} = conv2(im,fb{index1, index2},'same');
end
mat = zeros(nrows*ncols,numFilters);
for i = 1: 32
mat(:,i) = reshape(res{i}, nrows*ncols,1);
end

[cluster_idx,cluster_center] = kmeans(mat,64,'distance','sqEuclidean',...
    'Replicates',1,'MaxIter',500);

pixel_labels = reshape(cluster_idx,nrows,ncols);
tmap = pixel_labels;
%imshow(pixel_labels,[]),title('image labeled by cluster index');
imagesc(tmap);
colormap(jet);

end

