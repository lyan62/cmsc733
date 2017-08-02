function normal = calcNormal(group)
    E = group'*group;
    [U S V] = svd(E);
    normal = V(:,4);
end
