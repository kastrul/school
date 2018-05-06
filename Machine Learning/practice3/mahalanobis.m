function value = mahalanobis(point_1,point_2,covMat)
% this function returns mahalanobis distance betwwen two points with
% respect to the set described by covMat
value = sqrt((point_1-point_2)*covMat*(point_1-point_2)');
end