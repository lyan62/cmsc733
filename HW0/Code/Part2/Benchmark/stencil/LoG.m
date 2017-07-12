function L = LoG(size)
x = -floor(size/2):floor(size/2)
[x y] = meshgrid(x, x);
%[x y]=meshgrid(floor(-size/2)+1 :floor(size/2), floor(-size/2):floor(size/2));
    sigx = round(size/6, 2);
%sigy = 3.*sigx;
f=exp(-x.^2/(2*(sigx)^2)-y.^2/(2*(sigx)^2)).*(1-(x.^2/(2*(sigx)^2)+y.^2/(2*(sigx)^2)))./(-pi*sigx.^4);
%L = f;
%L=f./sum(f(:));
L=f/sum(abs(f(:)));

end
