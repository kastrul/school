clc
clear

load ovariancancer

data = dataset(500);
data = data.generate();
xTrain = data.x(1:300,:);
yTrain = data.y(1:300,:);
xTest = data.x(301:500,:);
yTest = data.y(301:500,:);

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
