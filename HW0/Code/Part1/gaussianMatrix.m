function G = gaussianMatrix(size)
x = -floor(size/2):floor(size/2);
[x y] = meshgrid(x, x);
%[x y]=meshgrid(floor(-size/2)+1 :floor(size/2), floor(-size/2):floor(size/2));
sigma = round((size-1)/6);
f=exp(-x.^2/(2*sigma^2)-y.^2/(2*sigma^2))./(2*pi*sigma*sigma);
G =f./sum(f(:));
end
