classdef Transformer
    %UNTITLED14 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        C1 = 0; 
        C2 = 0;
        Z = 0; 
        Y = 0; 
    end
    
    methods
        function obj = untitled14(c1, c2, imp)
            obj.C1 = c1;
            obj.C2 = c2; 
            obj.Z = imp; 
            obj.Y = inv(imp);
        end
        
    end
end

