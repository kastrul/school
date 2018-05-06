classdef Point
%POINT Summary of this class goes here
%   Detailed explanation goes here

properties
Coordinate % Coordinate of the point
Label % Label of the point
Index
end

methods
function obj=Point(coord, lbl, idx)
  obj.Coordinate = coord;
  obj.Label = lbl;
  obj.Index = idx;
end
end

methods (Static)
function out = toArray(points)
  array_long = [points.Coordinate];
  out = zeros(length(points), 2);
  for i = 1:length(points)
    out(i,:) = [array_long(i*2-1) array_long(i*2)];
  end
end

function out = toPoints(array)
  out = Point.empty;
  for i = 1:length(array)
    out(i) = Point(array(i,:), 0, i);
  end
end
end

end
