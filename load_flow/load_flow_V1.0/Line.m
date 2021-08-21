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
        function obj = Line(c1, c2, imp_real, imp_react)
            %UNTITLED13 Construct an instance of this class
            %   Detailed explanation goes here
            if nargin > 0
                obj.C1 = c1;
                obj.C2 = c2; 
                obj.Z = imp_real + imp_react * i; 
                obj.Y = inv(obj.Z);
                obj.I = 0;
            end

           
        end
        

    end
end
