function [output] = triangulation_method(FaceData1,FaceData2,I1,I2)
tri1 = delaunayTriangulation(FaceData1.LandMarks);
[tri1ID,pixel_coords1] = compute_triID(I1,FaceData1);
[bc,corrs_vertices] = compute_bc(pixel_coords1,FaceData1,tri1ID);
num_pixels = size(corrs_vertices,1);

%use tri1 for tri2!!!
tri2 = tri1(:,:);
DT = delaunayTriangulation(FaceData2.LandMarks);
[K,v] = convexHull(DT);
lm2 = FaceData2.LandMarks;
num_triangles = size(tri2,1);
for i = 1: num_triangles
   a_coord(i,:) = [lm2(tri2(i,1),1),lm2(tri2(i,1),2)];
   b_coord(i,:) = [lm2(tri2(i,2),1),lm2(tri2(i,2),2)];
   c_coord(i,:) = [lm2(tri2(i,3),1),lm2(tri2(i,3),2)];
end

%% compute M_2
%num_pixels = size(pixel_coords1,1);
for i = 1: num_pixels
    triID  = tri1ID(i);
    M_2{i} = [a_coord(triID,1) b_coord(triID,1) c_coord(triID,1);
        a_coord(triID,2) b_coord(triID,2) c_coord(triID,2);
        1 1 1];
end

pixel_vector2 = zeros(num_pixels,2);
for i  = 1:num_pixels
    pixel_position(i,:) = M_2{i}*bc{i};
    pixel_vector2(i,1) = round(pixel_position(i,1)/pixel_position(i,3));
    pixel_vector2(i,2) = round(pixel_position(i,2)/pixel_position(i,3));
end

%% try to do weighting(cross dissolve)

for i = 1:num_pixels
v1(i,:) = I1(pixel_coords1(i,2),pixel_coords1(i,1),:);
v2(i,:) = I2(pixel_vector2(i,2),pixel_vector2(i,1),:);
end
weight = mean(mean(v1)./mean(v2));

%% swap
for i = 1:num_pixels
    I1(pixel_coords1(i,2),pixel_coords1(i,1),:) = weight*I2(pixel_vector2(i,2),pixel_vector2(i,1),:);
end
output = I1;
end