% this script demonstrates rotation effect on mahalanaobis distance

clear 
clc

load('dataset_five_gaussians.mat');
covMat_1 = cov(D(1).set);
point_1 = [0,-2];

xlim = [-7, 5];
ylim = [-7; 5];

stepL = 0.5;

X=xlim(1):stepL:xlim(2);
Y=ylim(1):stepL:ylim(2);

aLength = length(X);

% surface Nr 1
for i = 1:aLength
    for j = 1:aLength
        Z_1(i,j) = mahalanobis(point_1,[X(i),Y(j)],covMat_1);
    end
end

[ROWS,~]=size(D(1).set);
DS_1=zeros(ROWS,1);
DS_2=zeros(ROWS,1)+0.1;

% coloring
Z_1_dif = max(Z_1) - min(Z_1);
C_1(:,:,1)=(Z_1 - min(Z_1))./Z_1_dif;
C_1(:,:,2)=(Z_1 - min(Z_1))./Z_1_dif;
C_1(:,:,3)=zeros(aLength,aLength);


theta = 0:2*pi/360:2*pi;

tLength=length(theta);

fh(1)=figure(1);

for k=1:tLength
    clf(fh(1))
    RotMat = [cos(theta(k)) -sin(theta(k)); sin(theta(k)) cos(theta(k))];
    D_rot=D(1).set*RotMat;
    covMat_2 = cov(D_rot);
    for i = 1:aLength
        for j = 1:aLength
            Z_2(i,j) = mahalanobis(point_1,[X(i),Y(j)],covMat_2);
        end
    end
    % coloring
    Z_2_dif = max(Z_2) - min(Z_2);
    C_2(:,:,3)=(Z_2 - min(Z_2))./Z_2_dif;
    scatter3(D(1).set(:,1),D(1).set(:,2),DS_1,10,'MarkerEdgeColor','black','MarkerFaceColor','yellow')
    hold on
    scatter3(D_rot(:,1),D_rot(:,2),DS_2,10,'MarkerEdgeColor','black','MarkerFaceColor','blue')
    hold on
    surf(X,Y,Z_1,C_1,'FaceAlpha',0.4)
    hold on
    surf(X,Y,Z_2,C_2,'FaceAlpha',0.4)
    hold on
    %view([-192,41])
    view([85,20])
    grid on
    axis equal
    pause(0.1)
end

