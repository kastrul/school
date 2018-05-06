
load('data_training.mat')
load('data_testing.mat')


dataTraining(dataTraining(:,3) == 4, 3) = 3;
dataTraining(dataTraining(:,3) == 1, 3) = 2;
dataTraining(dataTraining(:,3) == 0, 3) = 1;

lda = fitcdiscr(dataTraining(:,1:2),dataTraining(:,3));
ldaClass = resubPredict(lda);
[ldaResubCM,grpOrder] = confusionmat(dataTraining(:,3),ldaClass);

nbGau = fitcnb(dataTraining(:,1:2),dataTraining(:,3));
labels = predict(nbGau, dataTraining(:,1:2));
confusionmat(dataTraining(:,3),labels)

tree = fitctree(dataTraining(:,1:2),dataTraining(:,3));
labels_tree = predict(tree, dataTraining(:,1:2));
confusionmat(dataTraining(:,3),labels_tree)

figure;
for i=1:3
    subplot(3,1,i)
    scatter(dataTraining(labels_tree == i, 1), dataTraining(labels_tree == i, 2))
end

load('data_testing.mat')
labels_tree_unseen = predict(tree, dataTesting(:,1:2));

figure;
for i=1:3
    subplot(3,1,i)
    scatter(dataTesting(labels_tree_unseen == i, 1), dataTesting(labels_tree_unseen == i, 2))
end




