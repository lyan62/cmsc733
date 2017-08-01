function [triID,pixel_coords] = compute_triID(I1,FaceData1)
% input: image; FaceData
% output: the triangleID that each pixel falls in
%         coords of the points on the face(in the cvx hull)
tri1 = delaunayTriangulation(FaceData1.LandMarks);
[K,v] = convexHull(tri1);
edge1 = [min(tri1.Points(:,1)),max(tri1.Points(:,1)),min(tri1.Points(:,2)),max(tri1.Points(:,2))];
[xq,yq] = meshgrid(min(edge1):max(edge1),min(edge1):max(edge1));

in = inpolygon(xq,yq,FaceData1.LandMarks(K,1),FaceData1.LandMarks(K,2));
pixel_coords = zeros(size(xq(in),1),2);
pixel_coords(:,1) = xq(in);
pixel_coords(:,2) = yq(in);

%use tsearch
TRI1 = tri1(:,:);
triID = tsearchn(FaceData1.LandMarks, TRI1,pixel_coords);  
end