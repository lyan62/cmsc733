function [img_proc, mask] = create_mask(img,FaceData1)
sz = size(img)
k = convhull(FaceData1.LandMarks(:,2),FaceData1.LandMarks(:,1));

[YY,XX] = meshgrid(1:sz(1),1:sz(2));
in = inpolygon(XX(:),YY(:),FaceData1.LandMarks(k,1),FaceData1.Landmark(k,2));

mask = reshape(in,[sz(2),sz(1)])';
img_proc = bsxfun(@times,im2double(img),double(mask));
end
