function [G1, G2] = EdgeBar(sigx)
SUP = 49;
hsup=(SUP-1)/2;
[x,y]=meshgrid([-hsup:hsup],[hsup:-1:-hsup]);
%[x y]=meshgrid(floor(-size/2)+1 :floor(size/2), floor(-size/2):floor(size/2));

sigy = 3.*sigx;
f=exp(-x.^2/(2*(sigx)^2)-y.^2/(2*(sigy)^2))./(2*pi*sigx*sigx);
G1=f./sum(abs(f(:)));

%derivative
sobelop = [-1 0 1; -2 0 2; -1 0 -1];
f2 = conv2(G1,sobelop);
%f2 = -(x.*exp(- (x.^2)./(2.*sigx.^2) - (y.^2)./(2.*sigy.^2)))./(2.*sigx.^3.*sigy.*pi);
%f2 =(x.^2.*exp(- x.^2./(2.*sigma_x.^2) - y.^2./(2.*sigma_y.^2)))./(2.*sigma_x.^5.*sigma_y.*pi) - exp(- x.^2./(2.*sigma_x.^2) - y.^2./(2.*sigma_y.^2))./(2.*sigma_x.^3.*sigma_y.*pi);
G2 = f2./sum(abs(f2(:)));
end