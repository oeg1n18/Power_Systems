classdef Gaus_loadflow < Trans_lines & Buses
    %GAUS_LOAD_FLOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Gaus_loadflow()
           % This constructor uses the member functions to complete a loadflow
           disp('object created')
        end
        
        
        function obj = compute(obj,max_iter)
           iter = 0;
           max = max_iter;
           while iter < max
             
                   for i = 1:obj.imp_size(1)
                       if obj.Bus_objs(i).type == 1 % swing bus 
                           [P, Q] = obj.solveSlack(i);
                           obj.Bus_objs(i).P_g = P;
                           obj.Bus_objs(i).Q_g = Q;
                       elseif obj.Bus_objs(i).type == 2 % PQ bus 
                           [V, ang] = obj.solvePQ(i);
                           obj.Bus_objs(i).volt = V; 
                           obj.Bus_objs(i).angle = ang;            
                       elseif obj.Bus_objs(i).type == 3 % PV bus
                           [Q, ang] = obj.solvePV(i);
                           obj.Bus_objs(i).Q_l = Q;
                           obj.Bus_objs(i).angle = ang;
                       else
                           disp('Bus was neither of type swing, PQ or PV')
                           disp('check your data!')
                       end
                       obj.Bus_objs(2).angle
                   end
                iter = iter + 1;
           end
             for i = 1:obj.imp_size(1)
                fprintf('Bus%d:  %.2fV  %2.f rad \n', i, obj.Bus_objs(i).volt, obj.Bus_objs(i).angle);
            end
        end
        
        
        function [Vn, ang] = solvePQ(obj, i)
            % This function solves a single iteration of the gaus-seidel 
            % method to find the Voltage and angle at the PQ bus using 
            % It's previous value. 
            sum = 0;
            for j = 1:obj.imp_size(1)
                if i~=j       
                    rad = obj.Bus_objs(j).angle;
                    sum = sum + obj.Ybus(i,j) * complex(obj.Bus_objs(j).volt*cos(rad), obj.Bus_objs(j).volt*sin(rad));
                end
            end
            voltage = complex(obj.Bus_objs(i).volt * cos(obj.Bus_objs(i).angle), obj.Bus_objs(i).volt * sin(obj.Bus_objs(i).angle));
            term1 = (complex(obj.Bus_objs(i).P_l, -obj.Bus_objs(i).Q_l))/conj(voltage);
            Vnew = (1/obj.Ybus(i,i))*(term1 - sum);
            ang = angle(Vnew);
            Vn = abs(Vnew); 
        end
        
        
        
        function [Qnew, ang] = solvePV(obj, i)
        % This function solves for the Q and angle of the PV bus given 
        % It's constant voltage held by the exciter. 
            sum = 0;
            for j = 1:obj.imp_size(1)
                rad = obj.Bus_objs(j).angle;
                V = complex(obj.Bus_objs(j).volt*cos(rad), obj.Bus_objs(j).volt*sin(rad)); 
                sum = sum + obj.Ybus(i,j)*V;
            end
            rad = obj.Bus_objs(i).angle;
            Vk = complex(obj.Bus_objs(j).volt*cos(rad), obj.Bus_objs(j).volt*sin(rad));
            Qnew = -imag(Vk + sum);
            sum = 0;
            for j = 1:obj.imp_size(1)
                if i~= j 
                    voltage = complex(obj.Bus_objs(j).volt*cos(obj.Bus_objs(j).angle), obj.Bus_objs(j).volt*sin(obj.Bus_objs(j).angle));
                    sum = sum + obj.Ybus(i,j) * voltage;
                end
            end 
            voltage = complex(obj.Bus_objs(i).volt*cos(obj.Bus_objs(i).angle), obj.Bus_objs(i).volt*sin(obj.Bus_objs(i).angle));
            term1 = (complex(obj.Bus_objs(i).P_g, obj.Bus_objs(i).Q_g))/conj(voltage);
            ang = angle((1/obj.Ybus(i,i)) * (term1 - sum));
        end
        
        
        
        
        function [Pslack, Qslack] = solveSlack(obj, i)
            % This function should be called at the end of the load flow to
            % calculate the real and reactive power drawn from the
            % slack bus
            sum = 0;
            for j = 1:obj.imp_size(1)
                voltage = complex(obj.Bus_objs(j).volt*cos(obj.Bus_objs(j).angle), obj.Bus_objs(j).volt*sin(obj.Bus_objs(j).angle));
                sum = sum + obj.Ybus(i,j) * voltage;
            end
            voltage = complex(obj.Bus_objs(i).volt*cos(obj.Bus_objs(i).angle), obj.Bus_objs(i).volt*sin(obj.Bus_objs(i).angle));
            S = voltage * sum;
            Pslack = real(S); 
            Qslack = imag(S);
        end
        
        function disp_voltages(obj)
            for i = 1:obj.imp_size(1)
                fprintf('Bus%d:  %.2fV  %2f rad \n', i, obj.Bus_objs(i).volt, obj.Bus_objs(i).angle);
            end
        end
    end
end

