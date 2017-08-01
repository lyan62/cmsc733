function [bc, corrs_vertices,M_corners]= compute_bc(coords,FaceData1,triID)
tri1 = delaunayTriangulation(FaceData1.LandMarks);
TRI1 = tri1(:,:);
num_pixels = size(coords,1);
bc = cell(num_pixels,1);
landmarks1 = FaceData1.LandMarks;
%num_tri = size(TRI1,1);
num_vert = size(landmarks1,1);
corrs_vertices = zeros(num_pixels,3);
corner_a = zeros(num_pixels,2);
corner_b = zeros(num_pixels,2);
corner_c = zeros(num_pixels,2);
M_corners = cell(num_pixels,1);
for i  = 1:num_pixels
    corrs_vertices(i,:) = TRI1(triID(i),:);
    corner_a(i,:) = landmarks1(corrs_vertices(i,1),:);
    corner_b(i,:) = landmarks1(corrs_vertices(i,2),:);
    corner_c(i,:) = landmarks1(corrs_vertices(i,3),:);
    M_corners{i} = [corner_a(i,1) corner_b(i,1) corner_c(i,1);
        corner_a(i,2) corner_b(i,2) corner_c(i,2);
        1 1 1];
    pixel_vec = [coords(i,1);coords(i,2);1];
    invM = inv(M_corners{i});
    bc{i} = invM * pixel_vec;
end
end