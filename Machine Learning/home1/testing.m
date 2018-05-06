clear;
clc; % clear command window

%a = randn(5, 2);
%p0 = [0, 0];
b = [0, 1, 1; 2, 2, 1; 3, 3, 1; 4, 4, 2];
%c = abs(p0-b);
mean(b);

%c(1);

load('dataset_allar.mat');
% load('test_data.mat');
arr = DD;


% singleDist = DistanceFunctions.minkArrayDistances(p0, b, 2);
%[clustered, means] = kMeans.kMeaClustering(3, 50, flower_2);

clusters = kMeans.plotClusters(4, 20, arr);