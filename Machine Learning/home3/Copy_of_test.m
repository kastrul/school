clc
clear

load ovariancancer

data = dataset(500);
data = data.generate();
xTrain = data.x(1:300,:);
yTrain = data.y(1:300,:);
xTest = data.x(301:500,:);
yTest = data.y(301:500,:);

%xTrain = obs;
%yTrain = grp;
%xTest = obs;
%yTest = adaBoost.strToNumbered(grp);

bm = adaBoost(9);
bm = bm.fit(xTrain, yTrain);

p = bm.predictArray(xTest);

diff = ismember(p.*yTest, -1);
wrongClasses = sum(double(diff)) + sum(p == 0);
disp(wrongClasses + " wrong classifications.");
% %dist = ((p - yTest).^2);

