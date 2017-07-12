function [hdl hdr]= halfDisk(dsize,theta)
num_degrees = numel(theta);
num_sizes = numel(dsize);
hdl = cell(num_sizes,num_degrees);
hdr = cell(num_sizes,num_degrees);

for i  = 1:num_sizes
    s = dsize(i);
    [cl, cr] = circularMatrix(s);
    for j = 1:num_degrees
        hl = imrotate(cl,theta(j),'crop');
        hdl{i,j} = hl;
        hr = imrotate(cr,theta(j),'crop');
        hdr{i,j} = hr;
    end
end
end