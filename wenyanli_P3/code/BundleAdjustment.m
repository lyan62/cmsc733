function [Cset, Rset, X3D] = BundleAdjustment(K, Cr_set, Rr_set, X3D, ReconX, H_bundle, U_bundle, V_bundle)
% 1st level wrapper function for running sba
%% Inputs:
% (K, Cr_set, Rr_set, X3D, ReconX, V_bundle, Mx_bundle, My_bundle)
% K - Camera callibration Matrix
% Cr_set - Set of Camera Center Positions
% Rr_set - Set of Rotation matrices
% Pose is defined as P = KR[I,-C]
% X3D - 3D points corresponding to all possible feature points
% ReconX - An indicator vector to indicate if a particular point has a
%       valid 3D triangulation associated with it
% V - Visibility matrix (NxM) => N features, M poses
% Mx - Set of pixel x-coordinates for each feature => NxM
% My - Set of pixel y-coordinates for each featuer => NxM
%% Outputs
% Updated Cr_set, Rr_set and X3D 

%% Your code goes here
cP = cell(size(Rr_set));
mask = logical(ReconX);
num_features = sum(mask);
num_frames = length(Rr_set);
X = X3D(mask,:);
U = U_bundle(mask,:);
V = V_bundle(mask,:);
H = H_bundle(mask,:);
measurements = zeros(2*num_features,num_frames);
for i = 1:num_frames
    cP{i} = K*Rr_set{i}*[eye(3) -Cr_set{i}];
    measurements(:,i) = reshape([U(:,i) V(:,i)]',num_features*2,1);
end

[cP, X] = sba_wrapper(measurements, cP, X, K);
X3D(mask,:) = X;
for i = 1:num_frames
    H = K\cP{i};
    Rset{i} = H(1:3,1:3);
    Cset{i} = -Rr_set{i}'*H(:,4);
end
end
