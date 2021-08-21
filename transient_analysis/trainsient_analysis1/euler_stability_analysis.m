% Constants
H = 3.0;
delta_0 = 0.4179;
omega_0 = 2*pi*60;
omega_syn = omega_0;
delta_t = 0.01;
clear_angle = 1.1;
t = linspace(0, 0.85, 86);
fault_flag = 1;

delta = zeros(size(t));
omega = zeros(size(t));

%Initialise steady state conditions
delta(1) = delta_0;
omega(1) = omega_0;

for i = 1:85
    %fault accelerating power 
    if fault_flag == 1;
        P_a = 1.0 - 0.9152*sin(delta(i));
    else 
        P_a = 1.0 - 2.1353*sin(delta(i));
    end
    
    
    delta_plus = delta(i) + (omega(i) - omega_syn)*delta_t; 
    omega_plus_pu = (omega(i) + ((P_a * omega_syn)/(omega(i)*2*H))*delta_t)/omega_syn;
    d_delta_plus = omega_plus_pu - omega_syn;
    
    if fault_flag == 1;
        P_a_plus = 1.0 - 0.9152*sin(delta(i));
    else 
        P_a_plus = 1.0 - 2.1353*sin(delta(i));
    end
    
    d_omega_plus = ((P_a_plus*omega_syn)/(2*H*omega_plus_pu));
    d_delta = omega(i) - omega_syn;
    d_omega = ((P_a*omega_syn)/(2*H*(omega(i)/omega_syn)));

    omega(i+1) = omega(i) + ((d_omega + d_omega_plus)/2)*delta_t;
    delta(i+1) = delta(i) + ((d_delta + d_delta_plus)/2)*delta_t;

    if round(delta(i), 2) > clear_angle
       fault_flag = 0;
    end
    
end
    

tiledlayout(2,1)

% Top plot
nexttile
plot(t, omega)
title('Angular Speed')

% Bottom Plot
nexttile
plot(t, delta)
title('Power Angle')
hold on 

