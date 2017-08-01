function [imnew] = cylind(im)
rows = size(im,1);
cols = size(im,2);
f = 400;
xnew = 1:cols;
ynew = 1:rows;
xc = cols/2 + 1;
CX = ones(rows,cols).*xc;
[XN YN] = meshgrid(xnew, ynew);
Xorig = round(f.*atan((XN-CX)./f) + CX);
yc = rows/2 + 1;
CY = ones(rows,cols).*yc;
Yorig = round((YN-CY).*cos((Xorig-CX)./f)+CY);
imnew = zeros(rows,cols,3);
for i = 1:rows
for j = 1:cols
imnew(i,j,:) = im(Yorig(i,j),Xorig(i,j),:);
end
end