% this script playes a role of dataset constructor. 
clear
clc

% covariance matrices
cov(1).matrix = [4, 2; 2, 3];
cov(2).matrix = [2, -2; -2, 6];
cov(3).matrix = [1, -0.5; -0.5, 1];
cov(4).matrix = [1, -0.5; -0.5, 1];
cov(5).matrix = [1, -0.5; -0.5, 1];


% mean values
mean(1).mu = [2,0];
mean(2).mu = [1,0];
mean(3).mu = [-1,-2];
mean(4).mu = [2,0];
mean(5).mu = [6,2];

% sample sizes
n(1) = 500;
n(2) = 700;
n(3) = 100;
n(4) = 100;
n(5) = 100;

for i=1:5
    D(i).set = mvnrnd(mean(i).mu,cov(i).matrix,n(i)); 
end

fh(1) = figure(1);
clf(fh(1))
for i=1:5
    scatter(D(i).set(:,1),D(i).set(:,2))
    hold on
end

stepS = 0.1;
% generate more comples sets
t=-2:stepS:2;
tLength = length(t);
thicknes = 10;

DS1=[];
for i=1:tLength
    tSlice = rand(thicknes,2)*1.2;
    x(1:thicknes,1)=tSlice(:,1)+t(i);
    y(1:thicknes,1)=-tSlice(:,2)+t(i)^2;
    DS1 = [DS1;x,y];
end

DS2=[];
for i=1:tLength
    tSlice = rand(thicknes,2)*0.9;
    x(1:thicknes,1)=tSlice(:,1)+t(i)+2;
    y(1:thicknes,1)=tSlice(:,2)-t(i)^2+5.5;
    DS2 = [DS2;x,y];
end

fh(2)=figure(2);
clf(fh(2))
scatter(DS1(:,1),DS1(:,2))
hold on
scatter(DS2(:,1),DS2(:,2))
hold on
    








%flower like clusters
%cluster1

cov(1).matrix = [1, 0; 0, 1];
%cov(1).matrix = [4, 2; 2, 3];
cov(2).matrix = [1, -2; -2, 6];
cov(3).matrix = [1, 0.5; 0.5, 1];
cov(4).matrix = [1 -2; -2, 7];

n(3) = 350;
n(4) = 400;


mu(1,1).xy = [2,3];
mu(1,2).xy = [1,7];
mu(1,3).xy = [5,6];
mu(1,4).xy = [3.4,0];

flower_1 = [];
for i = 1:1
    for j = 1:4
        petal(i,j).set = mvnrnd(mu(i,j).xy,cov(j).matrix,n(j));
        flower_1 = [flower_1;petal(i,j).set];
    end
end


%cluster2 

cov(4).matrix = [2, 1; 1, 2];
%cov(1).matrix = [4, 2; 2, 3];
cov(3).matrix = [1, -2; -2, 6];
cov(2).matrix = [1, 0.5; 0.5, 1];
cov(1).matrix = [1 -2; -2, 7];

n(3) = 350;
n(4) = 400;


%mu(1,4).xy = [15,4];
mu(1,3).xy = [10,7];
mu(1,2).xy = [9,2];
mu(1,1).xy = [12,0];

flower_2 = [];
for i = 1:1
    for j = 1:3
        petal(i,j).set = mvnrnd(mu(i,j).xy,cov(j).matrix,n(j));
        flower_2 = [flower_2;petal(i,j).set];
    end
end



fh(4)=figure(4);
clf(fh(4))
scatter(flower_1(:,1),flower_1(:,2))
hold on
scatter(flower_2(:,1),flower_2(:,2))
% cluster2 



