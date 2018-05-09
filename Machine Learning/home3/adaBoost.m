classdef adaBoost
    properties
        x
        y
        M
        trees
        a
    end
    
    methods
        function obj = adaBoost(models)
            obj.M = models;
        end
        
        function obj = fit(obj, X, Y)
            obj = obj.setup(X, Y);
            obj = obj.trainModel();
        end
        
        function obj = setup(obj, X, Y)
            obj.x = X;
            if isnumeric(Y)
                obj.y = Y;
            else
                obj.y = adaBoost.strToNumbered(Y);
            end
        end
        
        %% main training function
        function obj = trainModel(obj)
            w = ones(length(obj.y), 1)/length(obj.y);
            eps = 10^-5;
            alpha = @(err) log((1-err + eps)/(err + eps));
            for m=1:obj.M
                obj.trees{m} = fitctree(obj.x, obj.y, 'Weights', w);
                % Classification error
                L = loss(obj.trees{m}, obj.x, obj.y, 'LossFun', 'classiferror');
                % Weight contribution calculation
                
                obj.a(m) = alpha(L);
                % Create new weights for incorrectly classified observations
                % pred = predict(obj.trees{m}, obj.x);
                % I = ismember(pred.*obj.y, -1);
                w = obj.updateWeights(w, m);
            end
        end
        %% for predicting a single value after training
        function out = predictSingle(obj, valueIn)
            pred = 0;
            for m=1:obj.M
                pred = pred + obj.a(m)*predict(obj.trees{m}, valueIn);
            end
            out = sign(pred);
        end
        %% for predicting an array after training
        function out = predictArray(obj, arrayIn)
            [N, ~] = size(arrayIn);
            out = zeros(N,1);
            for n=1:N
                out(n) = obj.predictSingle(arrayIn(n, :));
            end
        end
        %% updates weights after the end of every training iteration
        function out = updateWeights(obj, wOld, m)
            w = ones(length(wOld), 1)/length(wOld);
            if obj.a ~= Inf
                h = predict(obj.trees{m}, obj.x);
                diff = ismember(abs(h + obj.y), 2);
                for i=1:length(wOld)
                    w(i) = wOld(i)*exp(obj.a(m)*diff(i));
                end
            end
            out = w;
        end
    end
    
    %% ---Static helper methods---%
    methods(Static)
        % create an array which maps char value to +1 and -1
        function out = strToNumbered(arrayIn)
            strings = unique(arrayIn);
            if size(arrayIn, 2) ~= 1 || length(strings) ~= 2
                error('Invalid output array size!');
            end
            out = arrayfun(@(x) adaBoost.assignValue(x, strings), arrayIn);
        end
        
        function out = assignValue(x, strings)
            if strcmp(x, strings(1))
                out = 1;
            else
                out = -1;
            end
        end
        
        function out = errorfun(x, y)
            f = @(x) (1/2)*ln(x/(1-x));
            out = exp(-y*f(x));
        end
    end
end

