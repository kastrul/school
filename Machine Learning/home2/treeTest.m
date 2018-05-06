clc
clear

load Decision_tree
x = D_tree(:,1:4);
y = D_tree(:,5);

dt = DecisionTree;
dt = dt.fit(x, y);
dt.printTree(dt.tree, 1);


