clc
clear

testIn =  [1 2 3 4 5 6];
testOut = [1 4 9 16 25 36];

load classification_1
X = D_train;     % data vectors
Y = labels_train;  % data labels

xTest = D_valid;
yTest = labels_valid;

model = lm;
model = model.addLayer(2);
model = model.addLayer(2);
model = model.getWeights(2);
model = model.fit(X, Y);

pred = model.predictValues(xTest);

pdif = (yTest-pred)./pred*100;