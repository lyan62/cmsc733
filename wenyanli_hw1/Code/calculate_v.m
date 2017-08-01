function v = calculate_v(i,j,num_im,Hs)
%v = cell(1,num_im);
for n = 1:num_im
    v{n}=[Hs(1,i,n)*Hs(1,j,n) Hs(1,i,n)*Hs(2,j,n)+ Hs(2,i,n)*Hs(1,j,n) Hs(2,i,n)*Hs(2,j,n) Hs(3,i,n)*Hs(1,j,n)+Hs(1,i,n)*Hs(3,j,n) Hs(3,i,n)*Hs(2,j,n)+Hs(2,i,n)*Hs(3,j,n) Hs(3,i,n)*Hs(3,j,n)];
end
