classdef lm
    %LM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        layers % number of arrays here is number of layers
        W
        weights
    end
    
    methods
        function obj = lm()
            obj.layers = 0;
        end
        
        function obj = addLayer(obj, nNeurons)
            if obj.layers(1) == 0
                obj.layers(1) = nNeurons;
            else
                obj.layers(length(obj.layers) + 1) = nNeurons;
            end
        end
        
        function obj = getWeights(obj, nInputs)
            nOutputs = 1;
            
            nLayers = length(obj.layers);
            weightVars = cell(nLayers + 1, 1);
            for l=1:nLayers
                nNeurons = obj.layers(l);
                weightVars{l} = lm.createWeight(nInputs, nNeurons, l);
                nInputs = nNeurons;
            end
            weightVars{nLayers + 1} = lm.createWeight(nInputs, nOutputs, l+1);
            obj.W = lm.multiplyWeights(weightVars);
        end
        
        function obj = fit(obj, inData, outData)
            wValues = ones(1, length(symvar(obj.W)));
            ERR = outData - inData*obj.W;
            errorSym = symfun(ERR, symvar(obj.W));
            errorFun = matlabFunction(errorSym);
            error = @(w) lm.callOn(errorFun, w);
            options = optimoptions('lsqnonlin','Display','iter');
            options.Algorithm = 'levenberg-marquardt';
            [obj.weights, resnorm, residual, exitflag, output] = ...
                lsqnonlin(error, wValues, [], [], options);
        end
        
        function out = use(obj, in)
            F = 0;
            for i=1:length(in)
                F = F + in(i) * obj.W(i);
            end
            % F = in*obj.W;
            fSym = symfun(F, symvar(obj.W));
            fFun = matlabFunction(fSym);
            f = @(w) lm.callOn(fFun, w);
            out = f(obj.weights);
        end
        
        function out = predictValues(obj, array)
            out = [];
            for i=1:length(array)
                out(i,:) = obj.use(array(i,:));
            end
        end
    end
    
    methods (Static)
        function weight = createWeight(nInputs, nNeurons, nLayer)
            wShape = [nInputs, nNeurons];
            weight = sym(sprintf('w%d_',nLayer),wShape);
        end
        
        function W = multiplyWeights(weights)
            W = weights{1};
            for k = 2:length(weights)
                W = W * weights{k};
            end
        end
        
        function r = callOn(func, array)
            t = num2cell(array);
            r = func(t{:});
        end
    end
    
end

