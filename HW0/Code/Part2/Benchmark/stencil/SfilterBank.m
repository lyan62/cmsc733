%%
%%%create S filterBank
%%%sup = 49;
function S = SfilterBank(sup)
num_filters = 13;
st_pairs  = cell(1, num_filters);
sigma = [2 4 4 6 6 6 8 8 8 10 10 10 10];
tau = [1 1 2 1 2 3 1 2 3 1 2 3 4];
for i  = 1:num_filters
    st_pairs{1,i}(1) = sigma(i);
    st_pairs{1,i}(2) = tau(i);
end
S = cell(1,num_filters);
hsup = (sup-1)/2;
[x,y] = meshgrid([-hsup:hsup]);
r=(x.*x+y.*y).^0.5;
for i  = 1:num_filters,
S{i} = cos(pi*r*(st_pairs{1,i}(2))/st_pairs{1,i}(1)).*exp(-(r.*r)/(2*(st_pairs{1,i}(1)).^2));
S{i} = S{i}-mean(S{i}(:));
S{i} = S{i}./sum(abs((S{i}(:))));
end
end

