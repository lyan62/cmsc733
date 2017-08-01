function nim = vgg_warp_H(im, H, interp_mode, bbox_mode, verbose)

[m,n,l] = size(im);

% Make output image be the same class as input image
switch class(im)
 case 'double',  nim = double([]);
 case 'uint8',  nim = uint8([]);
end

if nargin<5
  verbose = 0;
end

% Assign default args
if nargin < 3
  interp_mode = 'linear';
end

if nargin < 4
  bbox_mode = 'img';
end

% Construct bb from bbox_mode
if isstr(bbox_mode)
  switch bbox_mode
  case 'fit'
    % Make bbox big enough to contain H * image_bbox
    y = H*[[1;1;1], [1;m;1], [n;m;1] [n;1;1]];
    y(1,:) = y(1,:)./y(3,:);
    y(2,:) = y(2,:)./y(3,:);
    bb = [
      ceil(min(y(1,:)));
      ceil(max(y(1,:)));
      ceil(min(y(2,:)));
      ceil(max(y(2,:)));
      ];
  case 'img'
    % Make bbox same size as image
    bb = [1 n 1 m];
  otherwise
    error('bbox_mode should be fit/img ');
  end
else % It's a matrix: bbox_mode IS the bbox
  if size(bbox_mode) ~= [1 4]
    error('bbox should be fit/img/[xmin xmax ymin ymax]')
  end
  bb = bbox_mode;
  if (bb(2) <= bb(1)) | (bb(4) <= bb(3))
    error('bbox should be [xmin xmax ymin ymax]')
  end
end

bb_xmin = bb(1);
bb_xmax = bb(2);
bb_ymin = bb(3);
bb_ymax = bb(4);

[U,V] = meshgrid(bb_xmin:bb_xmax,bb_ymin:bb_ymax);
[nrows, ncols] = size(U);

Hi = inv(H);

if 1
  % A Bit faster
  u = U(:);
  v = V(:);
  x1 = Hi(1,1) * u + Hi(1,2) * v + Hi(1,3);
  y1 = Hi(2,1) * u + Hi(2,2) * v + Hi(2,3);
  w1 = 1./(Hi(3,1) * u + Hi(3,2) * v + Hi(3,3));
  U(:) = x1 .* w1;
  V(:) = y1 .* w1;
end

% do linear interpolation
if 1
    if l == 3
        nim(nrows, ncols, 3) = 1;
        locprintf(verbose, 2, '[R ');
        nim(:,:,1) = interp2(im(:,:,1),U,V,interp_mode);
        locprintf(verbose, 2, 'G ');
        nim(:,:,2) = interp2(im(:,:,2),U,V,interp_mode);
        locprintf(verbose, 2, 'B] ');
        nim(:,:,3) = interp2(im(:,:,3),U,V,interp_mode);
    else
        nim(nrows, ncols) = 1;
        nim(:,:) = interp2(im(:,:),U,V,interp_mode,10);
    end
end

return

%%%%%%%%%

function locprintf(verbose,min_verb,varargin)
if verbose >= min_verb
  fprintf(varargin{:});
end
return