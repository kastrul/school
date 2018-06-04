clc
clear
s = 10;
iter = 40;
data = dataset(500, s);
data = data.generate();

data.x = randn(500, 15);
data.y = kmeans(data.x, 2);

data.y(data.y==1) = -1;
data.y(data.y==2) = 1;

len = length(data.x);
% xTrain = data.x(1:floor(len * 3/4),:);
% yTrain = data.y(1:floor(len * 3/4),:);
% xTest = data.x(floor(len * 3/4):len,:);
% yTest = data.y(floor(len * 3/4):len,:);
xTrain = data.x();
yTrain = data.y();
xTest = data.x();
yTest = data.y();

wrongClasses = zeros(iter,1);
for i=1:iter
    bm = adaBoost(i);
    bm = bm.fit(xTrain, yTrain);
    
    p = bm.predictArray(xTest);
    
    diff = ismember(p.*yTest, -1);
    wrongClasses(i) = sum(double(diff)) + sum(p == 0);
end

plot(linspace(1,iter,iter), wrongClasses);
xlabel('Boosting iterations');
ylabel('Incorrect observations');
