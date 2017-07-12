%create filter bank
%size = [5,7];
%theta =1:20:320; 
function fb = filterBank(sigmas, theta)
hsize = 6*sigmas + 1;
num_degrees = numel(theta);
num_sizes = numel(hsize);
fb = cell(numel(hsize),numel(theta));
sobelop = [-1 0 1; -2 0 2; -1 0 -1];
for i = 1:num_sizes
    c = conv2(gaussianMatrix(hsize(i)),sobelop);
    c = c/sum(sum(c));
    for j = 1:num_degrees
        f = imrotate(c, theta(j),'crop');
        fb{i,j}= f;
    end
end
end