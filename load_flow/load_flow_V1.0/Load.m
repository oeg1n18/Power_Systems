classdef Load
    %UNTITLED16 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bus = 0;
        S = 0
    end
    
    methods
        function obj = Load(Bus, s)
            %UNTITLED16 Construct an instance of this class
            %   Detailed explanation goes here
            obj.S = s;
            obj.bus = Bus;
        end
        
     
    end
end

