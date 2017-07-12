function [c_left,c_right] = circularMatrix(size)
c_left = zeros(2*size+1, 2*size+1);
c_right = zeros(2*size+1,2*size+1);
center_x = size + 1;
center_y = size + 1;
for i  = 1: 2*size+1
    for j = 1: size+1
        dx = i - center_x;
        dy = j - center_y;
        dx2 = dx ^ 2;
        dy2 = dy ^ 2;
        c_left(i, j) = dx2 + dy2 <= size^2;
    end
end
c_left = c_left./(sum(c_left(:)));

for i = 1:2*size+1
    for j = size+1 : 2*size+1
        dx = i - center_x;
        dy = j - center_y;
        dx2 = dx ^ 2;
        dy2 = dy ^ 2;
        c_right(i, j) = dx2 + dy2 <= size^2;
    end
end
c_right = c_right./(sum(c_right(:)));
end

