classdef DistanceFunctions
methods (Static)
% distance functions between TWO arbitrary dimensional points
function out = minkowski(p1, p2, p)
  dif = abs(p1-p2);
  out = power(sum(power(dif, p)), 1/p);
end


function out = manh(p1, p2)
  out = DistanceFunctions.minkowski(p1, p2, 1);
end


function out = eucl(p1, p2)
  out = DistanceFunctions.minkowski(p1, p2, 2);
end


function out = mink3(p1, p2)
  out = DistanceFunctions.minkowski(p1, p2, 3);
end


function out = cheb(p1, p2)
  out = max(abs(p1 - p2));
end


function out = canb(p1, p2)
  out = sum(abs(p1-p2)./(abs(p1) + abs(p2)));
end


function out = maha(p, array)
  S = cov(array)';
  dif = p - mean(array);
  out = sqrt(dif'*S*dif);
end


function out = cosd(p1, p2)
  up = sum(p1.*p2);
  down = sqrt(sum(abs(p1).^2))*sqrt(sum(abs(p2).^2));
  out = 1 - (up/down);
end

% distances of each array element to p0
function out = minkArrayDistances(p0, arr, p)
  [m, ~] = size(arr);
  out = zeros(m, 1);
  for i=1:m
    out(i) = DistanceFunctions.minkowski(p0, arr(i, :), p);
  end
end

end
end
