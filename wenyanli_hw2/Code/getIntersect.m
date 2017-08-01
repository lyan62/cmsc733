function vp = getIntersect(line1_paras,line2_paras)
syms x
solx = solve(line1_paras(1)*x + line1_paras(2) == line2_paras(1)*x + line2_paras(2), x);
inter_x = double(solx);
inter_y = line1_paras(1)*inter_x + line1_paras(2);
vp = [inter_x,inter_y];
plot(vp(1),vp(2),'+');
end