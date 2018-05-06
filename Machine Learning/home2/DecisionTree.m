classdef DecisionTree
    %DECISIONTREE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tY
        tree
        columnsX
        classes
        nodes
        X
        Y
    end
    
    methods
        function obj = DecisionTree()
        end
        
        function obj = fit(obj, trainX, trainY)
            if ~iscell(trainY)
                trainY = num2cell(num2str(trainY));
            end
            disp(trainY);
            obj.classes = DecisionTree.getClasses(trainY);
            [rowsX, obj.columnsX] = size(trainX);
            [rowsY, columnsY] = size(trainY);
            if rowsX ~= rowsY
                error('Error: Number of training data ' +...
                    'doesn`t match number of training classes.');
            end
            
            obj.X = trainX;
            obj.Y = trainY;
            for i=1:rowsX
                obj.X(i, obj.columnsX + 1) = i;
                obj.Y{i, columnsY + 1} = i;
            end
            obj.tree = obj.buildTree(obj.X, obj.Y);
        end
        
        function out = classify(obj, row, node)
            nodeType = class(node);
            if nodeType == "Leaf"
                disp(node.predictions);
                out = node.predictions;
            else
                if obj.match(node.question, row)
                    obj.classify(row, node.trueBranch);
                else
                    obj.classify(row, node.falseBranch);
                end
            end
            
        end
        
        function out = buildTree(obj, rowsX, rowsY)
            split = DecisionTree.bestSplits(rowsX, obj.Y);
            if split{1} == 0
                out = Leaf(obj.Y(rowsX(:, obj.columnsX + 1), :));
            else
                part = DecisionTree.partition(rowsX, split{2});
                tX = part{1};
                tY = obj.Y(tX(:, obj.columnsX + 1), :);
                trueBranch = obj.buildTree(part{1}, tY);
                tY = part{2};
                fY = obj.Y(tY(:, obj.columnsX + 1), :);
                falseBranch = obj.buildTree(part{2}, fY);
                out = DecisionNode(split{2}, trueBranch, falseBranch);
            end
        end
    end
    
    
    methods (Static)
        function printTree(tree, layernumber)
            attr = tree.question(1);
            value = tree.question(2);
            tBranch = tree.trueBranch;
            fBranch = tree.falseBranch;
            fprintf('Layer: %d; attr(%d) > %d\n\n', layernumber, attr, value);
            if isa(tBranch, 'Leaf')
                fprintf('## Layer: %d >=; ', layernumber);
                celldisp(tBranch.predictions);
            else
                DecisionTree.printTree(tBranch, layernumber + 1);
            end
            if isa(fBranch, 'Leaf')
                fprintf('## Layer: %d; <', layernumber);
                celldisp(fBranch.predictions);
            else
                DecisionTree.printTree(fBranch, layernumber + 1);
            end
        end
        
        % insert rowsX with  indexes
        function out = partition(rows, question)
            trueRows = [];
            trIdx = 1;
            falseRows = [];
            frIdx = 1;
            [rowN, ~] = size(rows);
            for i=1:rowN
                row = rows(i,:);
                if DecisionTree.match(question, row)
                    trueRows(trIdx,:) = row;
                    trIdx = trIdx + 1;
                else
                    falseRows(frIdx,:) = row;
                    frIdx = frIdx + 1;
                end
            end
            out = {trueRows, falseRows};
        end
        
        function out = gini(rowsY)
            counts = DecisionTree.getClasses(rowsY);
            impurity = 1;
            [rowN, ~] = size(counts);
            for i=1:rowN
                probOfLabel = counts{i, 2}/length(rowsY);
                impurity = impurity - probOfLabel^2;
            end
            out = impurity;
        end
        
        % insert trainY with indexes
        % returns array with columns 'class name', nr of occurrances
        function out = getClasses(trainY)
            [ii,jj,kk]=unique(trainY(:,1));
            f=histc(kk,1:numel(jj));
            out = cell(length(ii), 2);
            for i=1:length(ii)
                out{i, 1} = ii{i};
                out{i, 2} = f(i);
            end
        end
        
        function out = question(column, value)
            out = [column, value];
        end
        
        function out = match(question, row)
            if row(question(1)) >= question(2)
                out = 1;
            else
                out = 0;
            end
        end
        
        % insert target arrays as left(true) and right(false)
        function out = infoGain(left, right, uncertainty)
            p = length(left) / (length(left) + length(right));
            giniLeft = DecisionTree.gini(left);
            giniRight = DecisionTree.gini(right);
            out = uncertainty - p * giniLeft - (1 - p) * giniRight;
        end
        
        % insert rows with index number
        function out = bestSplits(rowsX, rowsY)
            bestGain = 0;
            bestQuestion = 0;
            uncertainty = DecisionTree.gini(rowsY);
            [rowsN, columnsN] = size(rowsX);
            for i=1:columnsN-1
                values = unique(rowsX(:, i));
                for j=1:length(values)
                    question = DecisionTree.question(i, values(j));
                    partition = DecisionTree.partition(rowsX, question);
                    trueR = partition{1};
                    falseR = partition{2};
                    if isempty(trueR) || isempty(falseR)
                        continue
                    end
                    trueRY = rowsY(trueR(:, columnsN), :);
                    falseRY = rowsY(falseR(:, columnsN), :);
                    gain = DecisionTree.infoGain(trueRY, falseRY, uncertainty);
                    if gain >= bestGain
                        bestGain = gain;
                        bestQuestion = question;
                    end
                    
                end
            end
            out = {bestGain, bestQuestion};
        end
    end
    
end

