clear
clc
load 'data';
p = [x,y];
s = size(x,1);
e = [p,ts,ones(s,1)];
delta_t = 1000;
% time boundaries
t_init = ts;
tminus = bsxfun(@minus,t_init,delta_t);
tplus = bsxfun(@plus, t_init, delta_t);
% coordinates boundaries
x_init = x;
y_init = y;
delta_x = 15;
delta_y = 15;
xminus = bsxfun(@minus,x_init,delta_x);
yminus = bsxfun(@minus,y_init,delta_y);
xplus = bsxfun(@plus,x_init,delta_x);
yplus = bsxfun(@plus,y_init,delta_y);
% get window of 121*121


%% 
% obtain data in the defined window
for i  = 1:s
    group_ind{i} = find(ts <= tplus(i) & ts >= tminus(i) & x <=xplus(i) & x >= xminus(i) & y <= yplus(i) & y >= yminus(i));
    group{i} = e(group_ind{i},:);   % events beside window for event i
    groupx{i} = group{i}(:,1);
    groupy{i} = group{i}(:,2);
end


%% apply pca for plane fitting

th1 = 1e-5;
th2 = 0.05;
epslion = 10e6;

for i  = 1:s
    if size(group{i},1) < 4
        vx(i) = 0;
        vy(i) = 0;
        i = i+1;
    else        
    normal = applyPCA(group{i}');
    while epslion > th1
        pi_est = abs(normal * group{i}');
        event_ind = find(pi_est < th2);
        group{i} = group{i}(event_ind,:);
        normal_old = normal;
        normal = applyPCA(group{i}');
        epslion = norm(normal_old - normal);
        normal_old = normal;
    end
    normal_vec(:,i) = normal; 
    vx(i) = -normal(1)*sign(normal(3));
    vy(i) = -normal(2)*sign(normal(3));
    end
end
%  quiver(x,y,vx',vy',0);


%% 
[unique_position,ind1,ind2] = unique(p,'rows');
% num = size(unique_position,1);
% quiver(p(ind1,1),p(ind1,2),normal_vec(1,ind1)',normal_vec(2,ind1)',0);

quiver(p(ind1,1),p(ind1,2),vx(ind1)',vy(ind1)',0);
hold on;
% neg = find(pol(ind1) == -1);
% quiver(p(neg,1),p(neg,2),vx(neg)',vy(neg)',0,'color',[0,0,1]);
% hold on;
% positive = find(pol(ind1) == 1);
% quiver(p(positive,1),p(positive,2),vx(positive)',vy(positive)',0,'color',[1,0,0]);
%% polarity separation
% uncomment to separate polarity
% neg = find(pol == -1);
% quiver(p(neg,1),p(neg,2),vx(neg)',vy(neg)',0,'color',[0,0,1]);
% hold on;
% positive = find(pol == 1);
% quiver(p(positive,1),p(positive,2),vx(positive)',vy(positive)',0,'color',[1,0,0]);





