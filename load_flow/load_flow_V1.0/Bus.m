classdef Bus
    %UNTITLED15 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id=0;
        type=0; % 1=swing, 2=PQ, 3=PV
        volt=0;
        angle=0;
        P_g=0;
        Q_g=0; 
        P_l=0; 
        Q_l=0;
        Q_g_min=0;
        Q_g_max=0;
    end
    
        
    methods
        function obj = Bus(id,type, V, angle, P_g, Q_g, P_l, Q_l, Q_g_min, Q_g_max)
            if nargin > 0
                obj.id = id;
                obj.type = type; 
                obj.volt = V; 
                obj.angle = angle; 
                obj.P_g = P_g; 
                obj.Q_g = Q_g; 
                obj.P_l = P_l; 
                obj.Q_l = Q_l;
                obj.Q_g_min = Q_g_min;
                obj.Q_g_max = Q_g_max;
            end
        end
    end
    
end

