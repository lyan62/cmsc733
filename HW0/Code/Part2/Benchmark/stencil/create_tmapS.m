function tmapS = create_tmapS(im,k)
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
sup = 49;
S = SfilterBank(sup);
numFilters = 13;
res = cell(1, numFilters);   %res is a 1*13 cell;


%compute the response after convolutions with filters
for i = 1:13
    res{i} = conv2(im,S{i},'same');
end
mat = zeros(nrows*ncols,numFilters);
for i = 1: numFilters
mat(:,i) = reshape(res{i}, nrows*ncols,1);
end

[cluster_idx,cluster_center] = kmeans(mat,k,'distance','sqEuclidean',...
    'Replicates',2,'MaxIter',500);

pixel_labels = reshape(cluster_idx,nrows,ncols);
tmapS = pixel_labels;
%imshow(pixel_labels,[]),title('image labeled by cluster index');
imagesc(tmapS);
colormap(jet);

end