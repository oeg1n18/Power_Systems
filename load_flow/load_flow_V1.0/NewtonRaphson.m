classdef NewtonRaphson < Trans_lines & Buses
    %UNTITLED17 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        M;
        N; 
        
    end
    
    methods
        function obj = NewtonRaphson()
            obj.N = obj.imp_size(1);
            count = 0;
            for i = 1:obj.N
                if obj.Bus_objs(i).type == 3
                    count = count + 1;
                end
            end
            obj.M = obj.N - (count);       
        end
        
        function obj = assume_initials(obj)
            %ASSUME_INITIALS assumes the initial data for the PQ and PV buses
            %  The voltage and angle are assumed for PQ buses
            % The real power is assumed for PV bus. 
            for i = 1:obj.N
                if obj.Bus_objs(i).type == 2 %PQ bus
                    obj.Bus_objs(i).volt = 1.0;
                    obj.Bus_objs(i).angle = 0.0;
                elseif obj.Bus_objs(i).type == 3 %PV bus
                    obj.Bus_objs(i).angle = 0.0;
                else
                    disp(' Error no PV or PQ buses found ');
                    disp(' Check data ');
                end
            end
        end
        
        function P = real_power(obj,i)
            %REAL_POWER calculates the real power of a bus from it's
            %voltage and angle's
            %
            sum = 0;
            for k = 1:obj.N
                admit_ang = angle(obj.Ybus(i,k));
                ang_k = obj.Bus_objs(k).angle;
                ang_i = obj.Bus_objs(i).angle;
                sum = sum + abs(obj.Ybus(i,k)) * obj.Bus_objs(k).volt * cos(admit_ang + ang_k + ang_i);
            end
            P = obj.Bus_objs(i).volt * sum;
        end
        
        function Q = reactive_power(obj,i)
            %REACTIVE_POWER calculates the reactive power of a bus from the
            %voltage and angle's on the bus. 
            sum = 0;
            for k = 1:obj.N
                admit_ang = angle(obj.Ybus(i,k));
                ang_k = obj.Bus_objs(k).angle;
                ang_i = obj.Bus_objs(i).angle;
                sum = sum + abs(obj.Ybus(i,k)) * obj.Bus_objs(k).volt * sin(admit_ang + ang_k + ang_i);
            end
            Q = -1 * obj.Bus_objs(i).volt * sum;
        end
        
        function del_p = delta_P(obj)
            %DELTA_P calculates the vector of differences for the newton
            %raphson calculation
            del_p = zeros((obj.N-1), 1);
            for i = 2:obj.N
                del_p(i-1) = obj.Bus_objs(i).P_l - obj.real_power(i);
            end
        end
        
        
        function del_Q = delta_Q(obj)
            %DELTA_Q calculates the vector of differences for the newton
            %raphson calculation
            del_Q = zeros((obj.M-1),1);
            index = 1;
            for i = 2:obj.N
                if obj.Bus_objs(i).type == 2 % PQ bus
                    del_Q(index) = obj.Bus_objs(i).P_l - obj.real_power(i);
                    index = index+1;
                end
            end
        end   

        function jacob = jacobian(obj)
            %JACOBIAN calcualtes the jacobian for the load flow equations. 
            J11 = zeros((obj.N-1), (obj.N-1));
            J12 = zeros((obj.N-1), (obj.M-1));
            J21 = zeros((obj.M-1), (obj.N-1));
            J22 = zeros((obj.M-1), (obj.M-1));
            J11_size = size(J11);
            J12_size = size(J12);
            J21_size = size(J21);
            J22_size = size(J22);

            %J11
            for i = 2:(J11_size(1)+1)
                for k = 2:(J11_size(2) + 1)
                    if i~=k
                        admit_ang = angle(obj.Ybus(i,k));
                        ang_k = obj.Bus_objs(k).angle;
                        ang_i = obj.Bus_objs(i).angle;
                        J11(i-1, k-1) = -obj.Bus_objs(i).volt * abs(obj.Ybus(i,k)) * obj.Bus_objs(k).volt * sin(admit_ang + ang_k - ang_i);
                    elseif i==k
                        Q = obj.reactive_power(i);
                        susceptance = abs(obj.Ybus(i,i)) * sin (angle(obj.Ybus(i,i)));
                        J11(i-1, k-1) = -Q - obj.Bus_objs(i).volt * susceptance;
                    end
                end
            end
            

            %J12 
            for i = 2:J12_size(1)+1
                for k = 2:J12_size(2)+1
                    if i~=k
                        admit_ang = angle(obj.Ybus(i,k));
                        ang_k = obj.Bus_objs(k).angle;
                        ang_i = obj.Bus_objs(i).angle;
                        J12(i-1, k-1) = obj.Bus_objs(i).volt * abs(obj.Ybus(i,k)) * cos(admit_ang + ang_k - ang_i);
                    else 
                        P = obj.real_power(i);
                        J12(i-1, k-1) = (P/obj.Bus_objs(i).volt) + obj.Bus_objs(i).volt * abs(obj.Ybus(i,i))*cos(angle(obj.Ybus(i,i)));
                    end
                end
            end

            %J21 
            for i = 2:J21_size(1)+1
                for k = 2:J21_size(2)+1
                    if i~=k
                        admit_ang = angle(obj.Ybus(i,k));
                        ang_k = obj.Bus_objs(k).angle;
                        ang_i = obj.Bus_objs(i).angle;
                        J21(i-1, k-1) = -obj.Bus_objs(i).volt * abs(obj.Ybus(i,k)) * cos (admit_ang + ang_k - ang_i);
                    else
                        admit_ang = angle(obj.Ybus(i,i));
                        P = obj.real_power(i);
                        J21(i-1,i-1) = P - obj.Bus_objs(i).volt * abs(obj.Ybus(i,i)) * cos(admit_ang);
                    end
                end
            end

            %J22
            for i = 2:J22_size(1)+1
                for k = 2:J22_size(2)+1
                    if i~=k
                        admit_ang = angle(obj.Ybus(i,k));
                        ang_k = obj.Bus_objs(k).angle;
                        ang_i = obj.Bus_objs(i).angle;
                        J22(i-1, k-1) = -obj.Bus_objs(i).volt * abs(obj.Ybus(i,k)) * sin(admit_ang + ang_k - ang_i);
                    else 
                        Q = obj.reactive_power(i);
                        admit_ang = angle(obj.Ybus(i,i));
                        J22(i-1,k-1) = (Q/obj.Bus_objs(i).volt) - obj.Bus_objs(i).volt * abs(obj.Ybus(i,i)) * sin(admit_ang);
                    end
                end
            end

            jacob = [J11 J12; J21 J22];  
        end
        
        
        
        function [delta_ang, delta_v] = compute_iter(obj)
            %COMPUTE_ITER calculates new values of the delta angle and
            %voltage. It computes a single iteration.
            jacob = obj.jacobian();
            del_p = obj.delta_P();
            del_q = obj.delta_Q();

            F = [del_p; del_q];
            jacob_inv = inv(jacob);
            corrections = mtimes(jacob_inv,F);
            delta_ang = corrections(1:obj.N-1,1);
            delta_v = corrections(obj.M+1:obj.N, 1);
        end
        
        function obj = compute(obj,tol)
            obj.check_dimensions();
            max_iter = 500;
            iter = 0;
            error = Inf;
            while abs(error) > tol && iter < max_iter
                [delta_ang, delta_v] = obj.compute_iter();
                for i = 1:obj.N-1
                    obj.Bus_objs(i).angle =  obj.Bus_objs(i).angle + delta_ang(i);
                end
                
                for i = 1:obj.M-1
                    obj.Bus_objs(i).volt = obj.Bus_objs(i).volt + delta_v(i);
                end
                
                delta_list = [delta_ang; delta_v];
                error = max(delta_list);
                iter = iter+1;
            end
            %compute the powers. 
            for i = 1:obj.N
                obj.Bus_objs(i).P_l = obj.real_power(i);
                obj.Bus_objs(i).Q_l = obj.reactive_power(i);
            end
            
            fprintf('iterations completed: %d\n ', iter);
            fprintf('Max error: %.5f\n', abs(error));
        end
                
                
            
        
        
        function disp_busdata(obj)
            for i = 1:obj.N
                fprintf("Bus%d type: %d  voltage: %.2f   angle: %.2f   P: %.2f   Q: %.2f\n", i, obj.Bus_objs(i).type, obj.Bus_objs(i).volt, obj.Bus_objs(i).angle*2*pi, obj.Bus_objs(i).P_l, obj.Bus_objs(i).Q_l);
            end
        end
        
        function check_dimensions(obj)
            del_p = obj.delta_P();
            del_q = obj.delta_Q();
            jacob = obj.jacobian();
            
            del_p_size = size(del_p);
            del_q_size = size(del_q);
            jacob_size = size(jacob);
            
            pass_count = 0;
            
            if jacob_size == [(obj.N-1 + obj.M-1), (obj.N-1 + obj.M-1)]
                disp('Jacobain PASSED')
                pass_count = pass_count + 1;
            else
                fprintf('Jacobian should be size (%d X %d) but is (%d X %d)', (obj.N + obj.M - 1),(obj.N + obj.M - 1), jacob_size(1), jacob_size(2)); 
            end

         
            
            if del_p_size == [obj.N-1, 1]
                disp('del_P PASSED');
                pass_count = pass_count + 1;
            else 
                fprintf('del_P should be size (%d X %d) but is (%d X %d) \n', obj.N-1, 1, del_p_size(1), del_p_size(2));
            end
            
            if del_q_size == [obj.M-1, 1]
                disp('del_Q PASSED');
                pass_count = pass_count + 1;
            else
                fprintf('del_Q should be size (%d X %d) but is (%d X %d) \n', obj.M-1, 1, del_1_size(1), del_q_size(2));
            end
            
            if pass_count == 3 
                disp(' --------- All Dimension Checks Passed ---------')
            end
                
        end
    end
end

