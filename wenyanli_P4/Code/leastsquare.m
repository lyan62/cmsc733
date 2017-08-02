clear
clc
load 'data';
p = [x,y];
s = size(x,1);
e = [p,ts,ones(s,1)];
delta_t = 250;
% time boundaries
t_init = ts;
tminus = bsxfun(@minus,t_init,delta_t);
tplus = bsxfun(@plus, t_init, delta_t);
% coordinates boundaries
x_init = x;
y_init = y;
delta_x = 20;
delta_y = 20;
xminus = bsxfun(@minus,x_init,delta_x);
yminus = bsxfun(@minus,y_init,delta_y);
xplus = bsxfun(@plus,x_init,delta_x);
yplus = bsxfun(@plus,y_init,delta_y);
% get window of 25*25


%% 
% obtain data in the defined window
for i  = 1:s
    group_ind{i} = find(ts <= tplus(i) & ts >= tminus(i) & x <=xplus(i) & x >= xminus(i) & y <= yplus(i) & y >= yminus(i));
    group{i} = e(group_ind{i},:);   % events beside window for event i
    groupx{i} = group{i}(:,1);
    groupy{i} = group{i}(:,2);
    groupt{i} = group{i}(:,3);
end

%% Use SVD for plane fitting and get the normal
% for i  = 1:s
%     E = group{i}'*group{i};
%     [U S V] = svd(E);
%     normal{i} = U(:,4);
% end

% normal = calcNormal(s,group);

%%
th1 = 1e-5;
th2 = 0.05;
epslion = 10e6;

% for i = 1:s 
%     pi_est{i} = abs(normal{i}' * group{i}');
%     event_ind{i} = find(pi_est{i} < th2);
%     group{i} = group{i}(event_ind{i},:);
%     normal_old = normal;
%     normal = calcNormal(s,group);
% end
    
%%
for i  = 1:s
    normal = calcNormal(group{i});
    while epslion > th1
        pi_est = abs(normal' * group{i}');
        event_ind = find(pi_est < th2);
        group{i} = group{i}(event_ind,:);
        normal_old = normal;
        normal = calcNormal(group{i});
        epslion = norm(normal_old - normal);
        normal_old = normal;
    end
%     vx(i) = -normal(3)/normal(1);
%     vy(i) = -normal(3)/normal(2);
    vx(i) = -normal(1)*sign(normal(3));
    vy(i) = -normal(2)*sign(normal(3));
    norm_vec(:,i) = normal;
    len_c(i) = abs(norm_vec(3,i));
end
        
%%
% % quiver(x,y,vx',vy',20);
[unique_position,ind1,ind2] = unique(p,'rows');
% num = size(unique_position,1);
% quiver(p(ind1,1),p(ind1,2),normal_vec(1,ind1)',normal_vec(2,ind1)',0);
quiver(p(ind1,1),p(ind1,2),vx(ind1)',vy(ind1)',10);


[unique_position,ind1,ind2] = unique(p,'rows');
% num = size(unique_position,1);
% quiver(p(ind1,1),p(ind1,2),normal_vec(1,ind1)',normal_vec(2,ind1)',10);
% positive = find(pol(ind1) == 1);
% quiver(p(positive,1),p(positive,2),vx(positive)',vy(positive)',5,'color',[1,0,0]);
% % quiver(p(ind1,1),p(ind1,2),vx(ind1)',vy(ind1)',0);
% hold on;
% neg = find(pol(ind1) == -1);
% quiver(p(neg,1),p(neg,2),vx(neg)',vy(neg)',5,'color',[0,0,1]);




    



