function [line,line_paras] = getLine(point1, point2,im)
% intput : point1 and point2 are the coordinates of the points selected
a = (point2(2)- point1(2))/(point2(1) - point1(1));
b = point2(2) - a*point2(1);
x = linspace(1,size(im,2));
line = a*x + b;
line_paras = [a,b];
plot(x,line);
end