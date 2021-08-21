

%===================== System Data ======================================

Vbus = ones(4,1); % all bus voltage values 
Vbusold = ones(4, 1); % old values used for iteration 
VbusDiff = ones(4, 1); % too check for accuracy 
PQbus = ones(4, 1); %power values at bus used in gaus seidel
Y = ones(4,4);   %Ybus matrix 

%========================================================================

Y(1,1) = Y(1,2) + Y(1,3) + Y(1,4);
Y(1,2) = inv(0.5 + 0.1i);
Y(1,3) = inv(0.5 + 0.1i);
Y(1,4) = 0;
Y(2,1) = inv(0.5 + 0.1i);
Y(2,2) = Y(2,1) + Y(2,3) + Y(2,4);
Y(2,3) = 0;
Y(2,4) = inv(0.5 + 0.1i);
Y(3,1) = inv(0.5 + 0.1i);
Y(3,2) = 0;
Y(3,3) = Y(3,4) + Y(3,2) + Y(3,1);
Y(3,4) = inv(0.5 + 0.1i);
Y(4,1) = 0;
Y(4,2) = inv(0.5 + 0.1i);
Y(4,3) = inv(0.5 + 0.1i);
Y(4,4) = Y(4,3) + Y(4,2) + Y(4,1);

PQbus(1) = 1.0 + 0j;
PQbus(2) = -0.5 + 0;
PQbus(3) = -0.25 + 0;
PQbus(4) = -0.2 - 0;

num_buses = size(Vbus);
num_buses = num_buses(1)
