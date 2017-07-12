function tmapLM = create_tmapMR(im)
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
sigx = [1 2 4];
theta = 1:30:180;
sigma = 10;
MR = MRfilterBank(sigma,sigx,theta);
numFilters = 38;
res = cell(1, numFilters);   %res is a 1*32 cell;


%compute the response after convolutions with filters
for i = 1:numFilters
    res{i} = conv2(im,MR{i},'same');
end
mat = zeros(nrows*ncols,numFilters);
for i = 1: numFilters
mat(:,i) = reshape(res{i}, nrows*ncols,1);
end

[cluster_idx,cluster_center] = kmeans(mat,64,'distance','sqEuclidean',...
    'Replicates',5);

pixel_labels = reshape(cluster_idx,nrows,ncols);
tmapLM = pixel_labels;
%imshow(pixel_labels,[]),title('image labeled by cluster index');
imagesc(tmapLM);
colormap(jet);

end
