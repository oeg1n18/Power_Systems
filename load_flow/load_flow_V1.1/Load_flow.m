classdef Load_flow < Trans & Busbars
    %UNTITLED18 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        delta_P
        delta_Q
        delta_Ang
        delta_V
        Property1
    end
    
    methods
        function obj = Load_flow(inputArg1,inputArg2)
            %UNTITLED18 Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function calc_delta_P(obj)
            obj.delta_P = zeros(obj.N-1, 1);
            for i = 2:obj.N
                P = obj.real_power(i);
                obj.delta_P(i) = obj.Buses(i).P - P;
            end
            
            dp_size = size(obj.delta_P);
            if size(obj.delta_P(i)) ~= [obj.N-1, 1]
                fprintf('delta_P should be (%d X %d) but is (%d X %d)\n', obj.N-1, dp_size(1), dp_size(2)); 
            end
        end
        
        
        function calc_delta_Q(obj)
            obj.delta_Q = zeros(obj.M, 1);
            index = 1;
            for i = obj.M+1:obj.N
                obj.delta_Q(index) = obj.Buses(i).Q - obj.reactive_power(i);
                index = index + 1;
            end
            
            dq_size = size(obj.delta_Q);
            if size(obj.delta_Q) ~= [obj.M, 1]
                fprintf('delta_Q should be (%d X %d) but is (%d X %d) \n',  obj.M, 1,dq_size(1), dq_size(2));
            end
        end
               
            
                
        
        function P = real_power(obj,i)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            sum = 0;
            angle_i = obj.Buses(i).angle;
            for k = 1:obj.N
                admit_angle = angle(obj.Ybus(i,k));
                angle_k = obj.Buses(k).angle;
                sum = sum + abs(obj.Ybus(i,k)) * obj.Buses(k).volt * cos(admit_angle + angle_k - angle_i);
            end
            P = obj.Buses(i).volt * sum;

        end
        
        function Q = reactive_power(obj, i)
            sum = 0;
            angle_i = obj.Buses(i).angle;
            for k = 1:obj.N
                admit_angle = angle(obj.Ybus(i,k));
                angle_k = obj.Buses(k).angle;
                sum = sum + abs(obj.Ybus(i,k)) * obj.Buses(k).volt * sin(admit_angle + angle_k - angle_i);
            end
            Q = -obj.Buses(i).volt * sum;
        end
        
        
        function J = DP_DA(obj, i, k)
            angle_i = obj.Buses(i).angle;
            admit_angle = angle(obj.Ybus(i,k));
            angle_k = obj.Buses(k).angle;
            if i ~= k
                J = obj.Buses(i).volt * abs(obj.Ybus(i,k)) * sin(admit_angle + angle_i - angle_k);
            else
                Q = obj.reactive_power(i);
                J = -Q - obj.Buses(i).volt * abs(obj.Ybus(i,k)) * cos(admit_angle);
            end
        end
        
        
        function J = DP_DV(obj, i, k) 
            angle_i = obj.Buses(i).angle;
            admit_angle = angle(obj.Ybus(i,k));
            angle_k = obj.Buses(k).angle;
            if i~=k
                J = obj.Buses(i).volt * abs(obj.Ybus(i,k)) * cos (admit_angle + angle_k - angle_i);
            else
                P = obj.real_power(i);
                J = (P/obj.Buses(i).volt) + abs(obj.Ybus(i,k)) * obj.Buses(i).volt * cos(admit_angle);
            end
        end
        
        function J = DQ_DA(obj, i, k)
            angle_i = obj.Buses(i).angle;
            admit_angle = angle(obj.Ybus(i,k));
            angle_k = obj.Buses(k).angle;
            if i~=k
                J = -obj.Buses(i).volt * abs(obj.Ybus(i,k)) * cos(admit_angle + angle_k - angle_i);
            else
                P = obj.real_power(i);
                J = P - obj.Buses(i).volt * abs(obj.Ybus(i,k)) * cos(admit_angle);
            end
        end
        
        
        function J = DQ_DV(obj, i, k)
            angle_i = obj.Buses(i).angle;
            admit_angle = angle(obj.Ybus(i,k));
            angle_k = obj.Buses(k).angle;
            if i~=k
                J = -obj.Buses(i).volt * abs(obj.Ybus(i,k)) * sin(admit_angle + angle_k - angle_i);
            else
                Q = obj.reactive_power(i);
                J = (Q/obj.Buses(i).volt) - obj.Buses(i).volt * abs(obj.Ybus(i,k)) * sin(admit_angle);
            end
        end
        
            
            
            
                
        
    end
end

