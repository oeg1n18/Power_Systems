classdef gen_salient
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        P %Poles 
        X_d
        X_q 
        X_l
        I_f % field current
        N_phase % Phase winding number 
        N_field % field winidng number
        rel % air-gap reluctance
        speed % speed 
        R_a
       
        
        
    end
    
    methods
        function obj = gen_round( P, X_d, X_q ,X_l, I_f, N_phase, N_field, rel, speed, R)
            obj.P = P; 
            obj.X_d = X_d;
            obj.X_q = X_q
            obj.X_l = X_l;
            obj.I_f = I_f; 
            obj.N_phase = N_phase;
            obj.N_field = N_field; 
            obj.rel = rel; 
            obj.speed = speed;
            obj.R_a = R;
            
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
            x_q = obj.X_q
            freq = obj.speed/(2*pi);
            M_f = (obj.N_phase * obj.N_field)/obj.rel;
            E_f = 4.44*freq*M_f*obj.I_f;
            E_q = E_f 
            P_round = (E_q * V)/x_d * sin(angle_gt);
            P_sal = (((obj.V(R_t, X_t)^2)*(x_d - x_q))/(2*x_d*x_q))*sin(2*angle_gt);
            P = P_round + P_sal;
        end
       
end