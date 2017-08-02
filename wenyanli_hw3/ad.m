
function diff = ad(im, num_iter, k, lambda, option)

if ndims(im)==3
  error('Anisodiff only operates on 2D grey-scale images');
end

im = double(im);
[rows,cols] = size(im);
diff = im;
  
for i = 1:num_iter
 fprintf('\rIteration %d',i);

  % Construct diffl which is the same as diff but
  % has an extra padding of zeros around it.
  diffl = zeros(rows+2, cols+2);
  diffl(2:rows+1, 2:cols+1) = diff;

  % North, South, East, West, NE, NW,SE, SW differences
  deltaN = diffl(1:rows,2:cols+1)   - diff;
  deltaS = diffl(3:rows+2,2:cols+1) - diff;
  deltaE = diffl(2:rows+1,3:cols+2) - diff;
  deltaW = diffl(2:rows+1,1:cols)   - diff;
  deltaNE = diffl(1:rows,3:cols+2) - diff;
  deltaNW = diffl(1:rows,1:cols) - diff;
  deltaSE = diffl(3:rows+2, 3: cols+2) - diff;
  deltaSW = diffl(3:rows+2, 1:cols) - diff;
  
  
  

  % Conduction

  if option == 1
    cN = exp(-(deltaN/k).^2);
    cS = exp(-(deltaS/k).^2);
    cE = exp(-(deltaE/k).^2);
    cW = exp(-(deltaW/k).^2);
    cNE = exp(-(deltaNE/k).^2);
    cSE = exp(-(deltaSE/k).^2);
    cSW = exp(-(deltaSW/k).^2);
    cNW = exp(-(deltaNW/k).^2);
  elseif option == 2
    cN = 1./(1 + (deltaN/k).^2);
    cS = 1./(1 + (deltaS/k).^2);
    cE = 1./(1 + (deltaE/k).^2);
    cW = 1./(1 + (deltaW/k).^2);
    cNE = 1./(1 + (deltaNE/k).^2);
    cSW = 1./(1 + (deltaSW/k).^2);
    cSE = 1./(1 + (deltaSE/k).^2);
    cNW = 1./(1 + (deltaNW/k).^2);
  end

  diff = diff + lambda*(cN.*deltaN + cS.*deltaS + cE.*deltaE + cW.*deltaW + cNE.*deltaNE + cSE.*deltaSE + cSW.*deltaSW + cNW.*deltaNW);

end
%fprintf('\n');
