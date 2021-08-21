classdef gen_round
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        P %Poles 
        X_a % armature reactance 
        X_l
        I_f % field current
        K_wf % field winding co-efficient
        N_phase % Phase winding number 
        N_field % field winidng number
        rel % air-gap reluctance
        speed % speed 
        R_a
    end
    
    methods
        function obj = gen_round(P, X_a,X_l, I_f, N_phase, N_field, rel, speed, R)
            obj.P = P; 
            obj.X_a = X_a; 
            obj.X_l = X_l;
            obj.I_f = I_f; 
            obj.N_phase = N_phase;
            obj.N_field = N_field; 
            obj.rel = rel; 
            obj.speed = speed;
            obj.R_a = R;
            
        end
        
        function [P_ag] = air_gap_power(obj, load_angle, I_m )
           M_f = (obj.N_phase * obj.N_field)/obj.rel;
           freq = obj.speed/(2*pi);
           E_f = 4.44 * freq * M_f * obj.I_f;
           % load angle is the angle between E_f and I
           % The angle between the field flux and air_gap flux 
           I = I_m/(2^0.5);
           P_ag = 3 * E_f * I * cos(load_angle);
        end
        
        
        function [Vg] = V_g(obj, armature_current)
            freq = obj.speed/(2*pi);
            M_f = (obj.N_phase * obj.N_field)/obj.rel;
            E_f = 4.44*freq*M_f*obj.I_f;
            real_vg = E_f - obj.R_a*armature_current; 
            comp_vg = (-obj.X_a - obj.X_l)*armature_current; 
            Vg = complex(real_vg, comp_vg);
        end
        
        function [V] = V(obj, R_t, X_t)
            freq = obj.speed/(2*pi);
            M_f = (obj.N_phase * obj.N_field)/obj.rel;
            E_f = 4.44*freq*M_f*obj.I_f;
            real_vg = E_f - obj.R_a*armature_current - R_t*armature_current; 
            comp_vg = (-obj.X_a - obj.X_l - X_t)*armature_current; 
            V = complex(real_vg, comp_vg);
        end
        
        function [P] = real_power(obj, R_t, X_t, angle_gt)
            % angle_gt is the angle between the generator rotor 
            % and the Voltage at the end of the generator/transformer
            % unit
            x_d = obj.X_a + X_t; 
            freq = obj.speed/(2*pi);
            M_f = (obj.N_phase * obj.N_field)/obj.rel;
            E_f = 4.44*freq*M_f*obj.I_f;
            E_q = E_f 
            P = (E_q * V)/x_d * sin(angle_gt);
        end
        
        function [Q] = reactive_power(obj, R_t, X_t, V_s, angle_gt) 
            %V_s is the busbar voltage
            x_d = obj.X_a + X_t; 
            freq = obj.speed/(2*pi);
            M_f = (obj.N_phase * obj.N_field)/obj.rel;
            E_f = 4.44*freq*M_f*obj.I_f;
            E_q = E_f;
            Q = (((E_q * V_s)/x_d)*cos(angle_gt) - (V_s)^2/x_d);
        end
    end
end

