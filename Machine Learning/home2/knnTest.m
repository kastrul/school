clear
clc

load classification_1
X = D_train;     % data vectors
Y = labels_train;  % data labels

xTest = D_valid;
yTest = labels_valid;
testPoint = [2.5 1.1];

z = knn;
z = z.fitData(X, Y);

pred = z.classifyDataSet(4, D_valid);

figure(1);
gscatter(xTest(:,1), xTest(:,2), pred);
figure(2);
gscatter(xTest(:,1), xTest(:,2), yTest);
