clc 
clear
format long

e = 10^(-5);
step = 0.1;
syms X Y;

g = Gradient;
g = g.setFunction(sin(X)*cos(Y), [X Y]);
g = g.descent(e, step);

fsurf(sin(X)*cos(Y));
hold on
plot3(g.points(:,1), g.points(:, 2), g.funValue, '--X', 'LineWidth', 3, 'MarkerSize', 10);