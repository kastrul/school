classdef knn
    
    properties
        X            % data vectors
        Y            % data labels
        minIdx
        minVal
        dist
        nn           % nearest neighbours labels
        prediction   % class of the point thats being classified
    end
    
    methods
        function obj = fitData(obj, x, y)
            obj.X = x;
            obj.Y = y;
        end
        
        function obj = findNN(obj, k, point)
            distances = DistanceFunctions.minkArrayDistances(point, obj.X, 2);
            [minValues, minIndices] = knn.getNMinValues(distances, k);
            obj.minVal = minValues;
            obj.minIdx = minIndices;
            obj.dist = distances;
            obj.nn = obj.Y(minIndices);
        end
        
        % Use this function when predicting categorical values
        function obj = classifyPoint(obj, k, point)
            obj = obj.findNN(k, point);
            obj.prediction = mode(obj.nn);
        end
        
        % Use this function when predicting continues values
        function obj = predictPointValue(obj, k ,point)
            obj = obj.findNN(k, point);
            obj.prediction = mean(obj.nn);
        end
        
        % k - number of nearest neighbours
        % point - data point which is being classified
        function obj = predictValue(obj, k, point)
            if iscategorical(obj.Y)
                obj = obj.classifyPoint(k, point);
            else
                obj = obj.predictPointValue(k, point);
            end
        end
        
        function out = getPrediction(obj)
            out = obj.prediction;
        end
        
        function out = classifyDataSet(obj, k, array)
            out = [];
            for i=1:length(array)
                obj = obj.classifyPoint(k, array(i,:));
                out(i,:) = obj.getPrediction;
            end
        end
    end
    
    
    methods (Static)
        function [out1, out2] = getNMinValues(array, n)
            [minValues, minIndices] = sort(array);
            out1 = minValues(1:n);
            out2 = minIndices(1:n);
        end
    end
    
end
