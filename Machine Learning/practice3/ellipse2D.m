function ellipse = ellipse2D(r_1,r_2,c_1,c_2,RotMat,stepsNr)
    % this function returns 2D array of integers representing coordinates of
    % the points of ellipse in 2D space
    theta = 0:(2*pi)/stepsNr:2*pi;
    theta_length = length(theta);

for i = 1:theta_length
    ellipse(i,1) = r_1*cos(theta(i));
    ellipse(i,2) = r_2*sin(theta(i));
end
ellipse=ellipse*RotMat;
ellipse(:,1)=ellipse(:,1)+c_1;
ellipse(:,2)=ellipse(:,2)+c_2;
end


