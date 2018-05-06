% this script playes a role of dataset constructor. 
clear
clc

% covariance matrices
cov(1).matrix = [4, 2; 2, 3];
[M1, V1] = eig(cov(1).matrix);
cov(2).matrix = [2, -2; -2, 6];
[M2, V2] = eig(cov(1).matrix);
cov(3).matrix = [1, -0.5; -0.5, 1];
[M3, V3] = eig(cov(1).matrix);
cov(4).matrix = [1, -0.5; -0.5, 1];
[M4, V4] = eig(cov(1).matrix);

% mean values
mean(1).mu = [2,10];
mean(2).mu = [0,0];
mean(3).mu = [-1,-4];
mean(4).mu = [5,5];

% sample sizes
n(1) = 500;
n(2) = 700;
n(3) = 400;
n(4) = 400;

combinedData = [];
for i=1:4
    D(i).set = mvnrnd(mean(i).mu,cov(i).matrix,n(i));
    D(i).set(:, 3) = ones(n(i), 1) * i;
    combinedData = [combinedData ; D(i).set];
end

p = randperm(size(combinedData, 1));
randomCombinedData = combinedData(p, :);

trainingSample = randomCombinedData(1:size(randomCombinedData,1) * 0.7, :);
vaidationSample = randomCombinedData(size(randomCombinedData,1) * 0.7 + 1 : end, 1 : 2);
vaidationSampleTrue = randomCombinedData(size(randomCombinedData,1) * 0.7 + 1 : end, :);

figure;
scatter(trainingSample(:, 1), trainingSample(:, 2))
figure;
scatter(vaidationSample(:, 1), vaidationSample(:, 2))
