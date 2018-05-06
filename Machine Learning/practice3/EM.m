% this script is to implement EM algorithm. 

%generate sets 
clear
clc

% covariance matrices  NB! this is not most ellegant way to generate
% covariance matrices
c(1).matrix = [4, 2; 2, 3];
c(2).matrix = [2, -2; -2, 6];
c(3).matrix = [1, -0.5; -0.5, 1];

% mean values
mu(1,:) = [2,0];
mu(2,:) = [12,0];
mu(3,:) = [-1,-10];

% sample sizes
n(1) = 500;
n(2) = 700;
n(3) = 600;


% generate gaussians and merge them into the single dataset
DD=[];
for i=1:3
    D(i).set = mvnrnd(mu(i,:),c(i).matrix,n(i)); 
    DD=[DD;D(i).set];
end

fh(1) = figure(1);
clf(fh(1))
for i=1:3
    scatter(D(i).set(:,1),D(i).set(:,2))
    hold on
end

K=3; % this is number of clusters, hyperparameter
[rows,~] =size(DD);
% Now let us fit the gaussians
% intialize
Pi=ones(K)*1/3; % initial responsibilities are set to be equal in the beginning
estim_mu=randn(K,2); % estimate of the centroids

% estimates of the covariance matrices for each cluster
c_estim(1).matrix =[1,3;4,2]*[3,0 ;0, 2]*[1,3;4,2]';
c_estim(2).matrix =[1,3;4,2]*[3,0 ;0, 2]*[1,3;4,2]';
c_estim(3).matrix =[1,3;4,2]*[3,0 ;0, 2]*[1,3;4,2]';


fh(2) = figure(2);

%now start mayn loop
exit_flag=0;
l=1;
while exit_flag==0
    % E step
    %recompute responsibilities 
    for i=1:rows
        for k=1:K
            tau(i,k) = Pi(k)*mvnpdf(DD(i,:),estim_mu(k,:),c_estim(k).matrix);
        end
        Tau(i)=sum(tau(i,:));
        for k=1:K
            r(i,k) = tau(i,k)/Tau(i);
        end
    end
    
    % M step
    for k=1:K
        Pi(k) = sum(r(:,k))/rows;
        %estim_mu
        
        for i=1:rows
            rr(i,:)=DD(i,:)*r(i,k);
        end
        estim_mu(k,:)=sum(rr)/sum(r(:,k));
        
        sumriks=zeros(2,2);
        
        for i=1:rows
            sumriks=sumriks+r(i,k)*DD(i,:)'*DD(i,:);
        end
        
        c_estim(k).matrix = sumriks/sum(r(:,k))-estim_mu(k,:)'*estim_mu(k,:);
    end
        
    % loglig   NB!  at this point you may update it.  
    for i=1:rows
        for k=1:K
            term1(k)=r(i,k)*log(Pi(k));
            term2(k)=r(i,k)*log(mvnpdf(DD(i,:),estim_mu(k,:),c_estim(k).matrix));
        end
        TERM1(i)=sum(term1);
        TERM2(i)=sum(term2);
    end
    l=l+1;
    loglik=sum(TERM1)+sum(TERM2);
    clear TERM1 TERM2 term1 term2
    
    
    clf(fh(2))
    scatter(DD(:,1),DD(:,2))
    hold on
    for k=1:K
        C=cov(c_estim(k).matrix);
        [a,b] = eig(c_estim(k).matrix);
        r_1 = sqrt(b(1,1));
        r_2 = sqrt(b(2,2));
        plot(estim_mu(k,1),estim_mu(k,2),'o','MarkerFaceColor','black','MarkerEdgeColor','blue','MarkerSize',10)
        hold on
        
        ellipse = ellipse2D(r_1,r_2,estim_mu(k,1),estim_mu(k,2),c_estim(k).matrix,20);
        plot(ellipse(:,1),ellipse(:,2))
    end
    pause(0.1)
    % please add convergence condition yourself
end
% NB!  we do not return hard clusters here. 
   