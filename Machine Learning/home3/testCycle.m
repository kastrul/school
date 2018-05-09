clc
clear
s = 10;
data = dataset(1000, s);
data = data.generate();
len = length(data.x);
% xTrain = data.x(1:floor(len * 3/4),:);
% yTrain = data.y(1:floor(len * 3/4),:);
% xTest = data.x(floor(len * 3/4):len,:);
% yTest = data.y(floor(len * 3/4):len,:);
xTrain = data.x();
yTrain = data.y();
xTest = data.x();
yTest = data.y();

wrongClasses = zeros(80,1);
for i=1:80
    bm = adaBoost(i);
    bm = bm.fit(xTrain, yTrain);
    
    p = bm.predictArray(xTest);
    
    diff = ismember(p.*yTest, -1);
    wrongClasses(i) = sum(double(diff)) + sum(p == 0);
end

plot(linspace(1,80,80), wrongClasses);
xlabel('Boosting iterations');
ylabel('Incorrect observations');
