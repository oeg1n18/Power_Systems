function [Y_bus] = getYbus(csvname)
%GETYBUS This function takes the name of the CSV file and creates the 
% Ybus addmittance matrix from the impedance matrix. 

impedance_tab = readtable(csvname);
Z_bus = table2array(impedance_tab);

%initialise the array
Y_bus_size = size(Z_bus);
Y_bus = zeros(Y_bus_size(1),Y_bus_size(2));

% Invert all the individual elements 
for i = 1:Y_bus_size(1)
    for j = 1:Y_bus_size(2)
        if Z_bus(i,j) == 0
            Y_bus(i,j) = 0;
        else 
            Y_bus(i,j) = 1/(Z_bus(i,j));
        end
    end
end

% Create the self admittance values
for i = 1:Y_bus_size(1)
    for n = 1:Y_bus_size(2)
        if n ~= i
            Y_bus(i,i) = Y_bus(i,i) + Y_bus(i,n);
        end
    end
end

end

