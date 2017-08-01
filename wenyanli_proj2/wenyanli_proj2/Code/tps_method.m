function morphed_im = tps_method(FaceData1,FaceData2,I1,I2)
tri1 = delaunayTriangulation(FaceData1.LandMarks);
[tri1ID,pixel_coords1] = compute_triID(I1,FaceData1);
[bc,corrs_vertices] = compute_bc(pixel_coords1,FaceData1,tri1ID);
num_pixels = size(corrs_vertices,1);

%use tri1 for tri2!!!
tri2 = tri1(:,:);
DT = delaunayTriangulation(FaceData2.LandMarks);
[K,v] = convexHull(DT);
lm2 = FaceData2.LandMarks;
lm1 = FaceData1.LandMarks;
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


%% get tps_params
%[a1_x,ax_x,ay_x,w_x] = est_tps3(lm1, lm2(:,1));
%[a1_y,ax_y,ay_y,w_y] = est_tps3(lm1, lm2(:,2));

[a1_x,ax_x,ay_x,w_x] = para_tps(lm1, lm2(:,1));
[a1_y,ax_y,ay_y,w_y] = para_tps(lm1, lm2(:,2));


%[pa1_x,pax_x,pay_x,pw_x] = estimate_tps(pixel_vector2, pixel_coords1(:,1));
%[pa1_y,pax_y,pay_y,pw_y] = estimate_tps(pixel_vector2, pixel_coords1(:,2));

%% get morph_img
[morphed_im,fx,fy] = morph_tps(I2, a1_x, ax_x, ay_x, w_x, a1_y,ax_y, ay_y,w_y,lm1, pixel_coords1,I1);
%imshow(morphed_im);
%H = fspecial('Gaussian',7,1);
%MotionBlur = imfilter(morphed_im,H,'replicate');
%imshow(MotionBlur);

%out_img = blending(I1,I2,pixel_coords1,fx,fy)
end












