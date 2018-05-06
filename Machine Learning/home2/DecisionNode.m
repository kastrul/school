classdef DecisionNode
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        question
        trueBranch
        falseBranch
    end
    
    methods
        function obj=DecisionNode(quest, tBranch, fBranch)
            obj.question = quest;
            obj.trueBranch = tBranch;
            obj.falseBranch = fBranch;
        end
    end
    
end

