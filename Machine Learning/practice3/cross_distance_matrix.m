function cross_distance_matrix = cross_distance_matrix(D,distfun,p)
% this function returns cross distance matrix

distfh=str2func(distfun);

if p==-1
    p = cov(D);
end
[rows,~]=size(D);

cross_distance_matrix=zeros(rows,rows);
for i=1:rows
    for j=1:rows
        cross_distance_matrix(i,j)=distfh(D(i,:),D(j,:),p);
    end
end

end