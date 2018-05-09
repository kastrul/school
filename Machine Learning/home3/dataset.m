classdef dataset
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state
        len
        x
        y
    end
    
    methods
        function obj = dataset(length)
            obj.state = rng;
            obj.len = length;
        end
        
        function obj = generate(obj)
            obj.x = normrnd(3, 10, [obj.len, 10]);
            obj.y = ones(obj.len, 1);
            for i=1:obj.len
                if sum(obj.x(i, :)) >  9.34
                    obj.y(i) = 1;
                else
                    obj.y(i) = -1;
                end
            end
        end
    end
end

