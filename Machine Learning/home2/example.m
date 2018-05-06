clc
clear

load classification_1
load Decision_tree
x = D_train;
y = labels_train;
xTest = D_valid;
yTest = labels_valid;

kn = knn;
kn = kn.fitData(x, y);
kn = kn.classifyPoint(4, [4, 3]);

