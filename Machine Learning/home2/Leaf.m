classdef Leaf
    %LEAF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        predictions
    end
    
    methods
        function obj = Leaf(r)
            obj.predictions = DecisionTree.getClasses(r);
        end
    end
    
end

