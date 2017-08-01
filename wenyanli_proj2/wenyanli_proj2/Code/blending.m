%% blending
function out_img = blending(I1,I2,pixel_coords1,fx,fy)
num_pixels = size(pixel_coords1,1);
msk = zeros(size(I1));

[Lh Lv] = imgrad(I1(pixel_coords1(:,2),pixel_coords1(:,1),:));
[Gh Gv] = imgrad(I2(fy(:),fx(:),:));
for i = 1:num_pixels
msk(pixel_coords1(i,2),pixel_coords1(i,1),:) = 1;
end


X = I1;
Fh = Lh;
Fv = Lv;
%msk = zeros(size(X));
for i = 1:num_pixels
X(pixel_coords1(i,2),pixel_coords1(i,1),:) = I2(fy(i),fx(i),:);
Fh(pixel_coords1(i,2),pixel_coords1(i,1),:) = Gh(fy(i),fx(i),:);
Fv(pixel_coords1(i,2),pixel_coords1(i,1),:) = Gv(fy(i),fx(i),:);
%msk(pixel_coords1(i,2),pixel_coords1(i,1),:) = 1;
end

imwrite(uint8(X),'X.png');

tic;
Y1 = PoissonJacobi( X, Fh,Fv, msk );
figure, imshow(Y1);
toc
imwrite(uint8(Y1),'Yjc.png');
tic;
Y2 = PoissonGaussSeidel( X, Fh, Fv, msk);
toc
out_img = Y2;
figure,imshow(Y2);
imwrite(uint8(Y2),'out.png');
end

