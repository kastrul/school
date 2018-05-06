classdef Gradient
    
    properties
        func    % function definition
        args    % input variables
        diffs   % partial derivatives
        
        points  % all the travelled points over the descent
        funValue % function values at every point
    end
    
    methods
        function obj = setFunction(obj, fun, in)
            f = symfun(fun, in);
            obj.func = formula(f);
            obj.args = argnames(f);
        end
        
        function obj = descent(obj, e, step)
            obj.diffs = obj.findDiffs;
            obj.points = ones(1, length(obj.args));
            obj.funValue(1,:) = 1;
            obj = obj.minimize(e, step);
        end
        
        function obj = minimize(obj, e, step)
            grad = obj.gradAtPoint(obj.points(1, :));
            direction = -(grad);
            i = 1;
            while norm(grad) > e
                currentPoint = obj.points(i, :);
                change = direction * step;
                obj.points(i+1,:) = currentPoint + change;
                i = i+1;
                grad = obj.gradAtPoint(obj.points(i,:));
                direction = -(grad);
                
                fValue = subs(obj.func, obj.args, currentPoint);
                obj.funValue(i,:) = fValue; 
                txtPoint = sprintf('%s', num2str(currentPoint, ' %0.4f '));
                txtChange = sprintf('%s', num2str(double(change), ' %0.4f '));
                fprintf('f(%s) = %0.4f;   Change [%s]\n',...
                    txtPoint, fValue, txtChange);
            end
        end
        
        function out = findDiffs(obj)
            out = sym.zeros(1, length(obj.args));
            for v=1:numel(obj.args)
                out(v) = diff(obj.func, obj.args(v));
            end
        end
        
        function out = gradAtPoint(obj, point)
            if length(obj.diffs) ~= length(point)
                error('Error: Number of partial derivatives' +...
                    'doesn`t match number of variables');
            end
            out = sym.zeros(1, length(obj.diffs));
            for d=1:length(obj.diffs)
                out(d) = subs(obj.diffs(d), obj.args, point);
            end
        end
    end
end

