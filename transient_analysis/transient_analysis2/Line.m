classdef Line
    %UNTITLED13 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        C1 = 0;
        C2 = 0; 
        Z = 0; 
        Y = 0;
        I = 0;
    end
    
    methods
        function obj = Line(c1, c2, imp)
            %UNTITLED13 Construct an instance of this class
            %   Detailed explanation goes here
            obj.C1 = c1;
            obj.C2 = c2; 
            obj.Z = imp; 
            obj.Y = inv(imp);
            obj.I = 0;
            
           
        end
        

    end
end
