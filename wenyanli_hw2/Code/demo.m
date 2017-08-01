im = imread('./Data/door.jpg');
addpath(genpath('./Code/'));
im = imresize(im,[1000 NaN]);
imshow(im);
hold on;
%%
leftup1 = [53,211];
leftup2 = [100,254];

rightup1 = [712,181];
rightup2 = [673,229];

leftbtm1 = [58,714];
leftbtm2 = [127,682];

rightbtm2 = [657,685];
rightbtm1 = [717,723];

% more points
groundleft = [54 721];
groundright = [716 722];
%% get line from two points

[leftupl,leftupl_paras] = getLine(leftup1,leftup2,im);
[rightupl,rightupl_paras] = getLine(rightup1,rightup2,im);
[leftbtml,leftbtml_paras] = getLine(leftbtm1,leftbtm2,im);
[rightbtml,rightbtml_paras] = getLine(rightbtm1,rightbtm2,im);


[groundll,groundll_paras]= getLine(groundleft,groundright,im);
[groundul,groundul_paras] = getLine(leftbtm2,rightbtm2,im);



%% solve for vanishing points
vp1 = getIntersect(leftupl_paras, leftbtml_paras);
vp2 = getIntersect(rightupl_paras,rightbtml_paras);
vp = 0.5*(vp1+vp2);
plot(vp(1),vp(2),'y*');
hold on
%plot([1 size(im,2)],[vp(2) vp(2)],'--');  %obtain horizontal vanishing line
%plot([387 387],[0 681],'c:');   % obtain vertical vanishing line


vp3 = getIntersect(groundll_paras,groundul_paras);  %obtain vanishing pt2 
[horizon, horizon_paras] = getLine(vp,vp3,im);   % obtain horizontal vanishing line 
%% obtain vanishing pt on the z axis
[leftl,leftl_paras] = getLine(leftup1,leftbtm1,im);
[rightl,rightl_paras] = getLine(rightup1,rightbtm1,im);

vpz = getIntersect(leftl_paras,rightl_paras);
%disp(sprintf('The position of the vanishing point on the z axis is (%.3f , %.3f)',vpz(1),vpz(2)));
%plot(vpz(1),vpz(2),'*');

%% obtain vanishing point on the horizontal line
doorbtm = [387,681];
doorh = [387,248];
doorup = [387,378];
foot = [467,726];
head = [467,459];
[foot2doorl,foot2doorl_paras] = getLine(doorbtm,foot,im);
%vanishingpt = getIntersect(foot2doorl_paras,[0 vp(2)]);
vanishingpt = getIntersect(foot2doorl_paras,horizon_paras);
plot(vanishingpt(1),vanishingpt(2),'wo');
[vp2headl,vp2headl_paras] = getLine(vanishingpt,head,im);

%doorpt = [doorbtm(1),vp2headl_paras(1)*doorbtm(1)+vp2headl_paras(2)];

%get vertical vanishing line
[verticall,verticall_paras] = getLine(doorbtm,vpz,im);
doorpt = getIntersect(verticall_paras,vp2headl_paras);
plot(doorpt(1),doorpt(2),'*');

%%
h_prime = abs(doorpt(2)-doorbtm(2));
%hr = abs(doorh(2)-doorbtm(2));
hr = abs(doorup(2) - doorbtm(2));
H_door = 1680*hr/h_prime;
%H_camera = abs(vp(2)-doorbtm(2))/abs(vp(2)-foot(2))*169;
H_camera = abs(vp(2)-doorbtm(2))/hr*H_door;

disp(sprintf('The height of the door is %.3f mm',H_door));
disp(sprintf('The height of the camera is %.3f mm',H_camera));


