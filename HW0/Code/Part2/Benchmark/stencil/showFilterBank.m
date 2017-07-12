function showfb = showFilterBank(fb)
for j = 1:size(fb,1)
    for i  = 1: size(fb,2)
        index = size(fb,2)*(j-1) + i;
    subplot(size(fb,1),size(fb,2),index);
    imagesc(fb{j,i});
    colormap(gray);
    end
end
end