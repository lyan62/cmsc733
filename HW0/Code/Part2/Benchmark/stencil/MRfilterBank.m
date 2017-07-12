function MR = MRfilterBank(sigma,sigx,theta)
num_degrees = numel(theta);
num_sizes = numel(sigx);
fb1 = cell(num_sizes,num_degrees);
fb2 = cell(num_sizes,num_degrees);
MR = cell(1,38);
sobelop = [-1 0 1; -2 0 2; -1 0 -1];
for i = 1:num_sizes
    [G1,G2] = EdgeBar(sigx(i));
    c1 = conv2(G1,sobelop);
    c2 = conv2(G2,sobelop);
    c1 = c1./sum(abs(sum(c1)));
    c2 = c2./sum(abs(sum(c2)));
    for j = 1:num_degrees
        ff1 = imrotate(c1, theta(j),'crop');
        fb1{i,j}= ff1;
        index = (i-1)*num_degrees + j;
        MR{index} = fb1{i,j};
        ff2 = imrotate(c2, theta(j),'crop');
        fb2{i,j} = ff2;
        MR{index+18} = fb1{i,j};
    end
end
gausize = sigma*6+1;
fb4 = LoG(gausize);
MR{38} = fb4;
fb3 = gaussianMatrix(gausize);
MR{37} = fb3;
end