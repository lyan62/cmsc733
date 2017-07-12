%%%LMfilterBank
%create a LM filter bank
%s = [sqrt(2), 2, 2*sqrt(2),4]; %sigma value
%ssize = round(6.*s + 1, 2);
%theta =1:60:360; 
function LM = LMfilterBank(sigx, theta)
num_degrees = numel(theta);
num_sizes = numel(sigx)-1;
fb1 = cell(num_sizes,num_degrees);
fb2 = cell(num_sizes,num_degrees);
LM = cell(4,12);
sobelop = [-1 0 1; -2 0 2; -1 0 -1];
for i = 1:num_sizes
    [G1,G2] = elongedGM(sigx(i));
    c1 = conv2(G1,sobelop);
    c2 = conv2(G2,sobelop);
    c1 = c1./sum(abs(sum(c1)));
    c2 = c2./sum(abs(sum(c2)));
    for j = 1:num_degrees
        ff1 = imrotate(c1, theta(j),'crop');
        fb1{i,j}= ff1;
        ff2 = imrotate(c2, theta(j),'crop');
        fb2{i,j} = ff2;
    end
end
fb3 = cell(1,numel(sigx)*2);
for i = 1 : numel(sigx)
    gaussize = sigx*6 +1;
    fb3{i} = LoG(gaussize(i));
    fb4{i} = gaussianMatrix(gaussize(i));
end
for i = (numel(sigx)+1): (2*numel(sigx))
    fb3{i} = LoG(gaussize(i-numel(sigx))*3);
end
for i = 1:numel(sigx)
    if i <4,
    for j = 1:num_degrees
        LM{i,j} = fb1{i,j};
        LM{i,j+num_degrees} = fb2{i,j};
    end
    else
        for j = 1:8
            LM{i,j} = fb3{j};
        end
        for j = 9:12
            LM{i,j} = fb4{j-8};
        end
    end
end
end
