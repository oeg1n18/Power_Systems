classdef Bus
    %UNTITLED15 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = 0.0; 
        type = 0.0; %1=slack, 2 = PQ, 3 = PV
        s = 0.0; %apparent power 
        volt = 0.0; 
    end
    
        
    methods
        function obj = Bus(id, voltage, angle, P, Q, type)
            obj.ID = id;
            obj.type = type; %1=swing, 2 = PQ, 3 = PV
            obj.s = complex(P,Q);
            obj.volt = complex((voltage*cos(angle)), (voltage*sin(angle)));
            
        end
        
     
    end
    
end

