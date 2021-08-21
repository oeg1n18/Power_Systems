


%===================== System Data ======================================

Vbus = ones(4,1); % all bus voltage values
Vbustype = (4,1); % determines the type 1=PV, 2 =PQn
Vbusold = ones(4, 1); % old values used for iteration 
VbusDiff = ones(4, 1); % too check for accuracy 
PQbus = ones(4, 1); %power values at bus used in gaus seidel
Y = ones(4,4);   %Ybus matrix 

%========================================================================

Y(1,1) = Y(1,2) + Y(1,3) + Y(1,4);
Y(1,2) = -inv(0.5 + 0.0i);
Y(1,3) = -inv(0.5 + 0.0i);
Y(1,4) = 0;
Y(2,1) = -inv(0.1 + 0.0i);
Y(2,2) = Y(2,1) + Y(2,3) + Y(2,4);
Y(2,3) = 0;
Y(2,4) = -inv(0.1 + 0.0i);
Y(3,1) = -inv(0.1 + 0.0i);
Y(3,2) = 0;
Y(3,3) = Y(3,4) + Y(3,2) + Y(3,1);
Y(3,4) = -inv(0.1 + 0.0i);
Y(4,1) = 0;
Y(4,2) = -inv(0.1 + 0.0i);
Y(4,3) = -inv(0.1 + 0.0i);
Y(4,4) = Y(4,3) + Y(4,2) + Y(4,1);

PQbus(1) = 1.0 + 0j;
PQbus(2) = -0.3 + 0i;
PQbus(3) = -0.1 + 0i;
PQbus(4) = -0.1 + 0.0i;

num_buses = size(Vbus);
num_buses = num_buses(1);

%========================= Solver =====================================
error_limit = 0.005;
error = 1.0;

for v = 1:30
    for k = 2:num_buses
        sum = 0;
        for n = 2:num_buses
            if k ~= n
                sum = sum + Y(k,n)*Vbusold(n);
            end
        end
        
        Vbus(k) = (1/Y(k,k))*((PQbus(k)/Vbusold(k)) - sum);
        VbusDiff(k) = abs(Vbus(k) - Vbusold(k))
        Vbusold(k) = Vbus(k);
        
    end
    
    error_sum = 0;
    for q = 1:num_buses
        error_sum = error_sum + VbusDiff(q);
    end
    error = (error_sum/num_buses);
end



for i = 1:num_buses 
    fprintf('Bus: %1.2f ------- Voltage:  %1.2f ------- error:  %1.2f  \n', i, Vbus(i), VbusDiff(i));
end
                
                
                
            