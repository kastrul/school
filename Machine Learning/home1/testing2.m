clear
clc
load('DD2.mat')

points = Point.toPoints(DD);
array = Point.toArray(points);

r = dbscan.clusters(points, 1, 6);
% array = [points2.Coordinate];
% graphing
%scatter(DD(:,1),DD(:,2));
dbscan.drawClusters(r);
grid on;