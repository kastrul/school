classdef kMeans
    % K - number of estimated clusters
    methods(Static)        
        
        function [clusters, means] = kMeansClustering(K, epochs, array)
            [m, n] = size(array);
            means = rand(K, n);
            min_arr = min(array);
            max_arr = max(array);
            means = min_arr + (max_arr - min_arr).*rand(K, n);
            clusters = zeros(m, 1);
            
            for e=1:epochs           

                for i=1:m
                    distances = DistanceFunctions.minkArrayDistances(array(i,:), means, 1);
                    [~, min_idx] = min(distances.^2);
                    clusters(i, 1) = min_idx;              
                end
                 
              
                for i=1:K
                    RGB = [i/5 i/5 i/5];
                    % scatter(means(i,1), means(i, 2), 500, RGB, '+');
                    % hold on;
                    cluster = array(clusters(:, 1)==i, :);
                    means(i, :) = mean(cluster);
                end
            end            
        end
        
        
        function out = plotClusters(K, epochs, array)
            [cluster_labels, centroids] = kMeans.kMeansClustering(K, epochs, array);
            
            for i=1:K
                cluster = array(cluster_labels(:, 1)==i, :);
                scatter(cluster(:,1), cluster(:,2), [], 'filled');
                hold on;
                scatter(centroids(i,1), centroids(i, 2), 800, 'pentagram', 'filled');
                hold on;
            end
            out = [array, cluster_labels];
        end
    end    
end