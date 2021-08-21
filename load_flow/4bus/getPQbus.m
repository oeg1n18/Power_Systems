function [PQbus] = getPQbus(csvname)
%PQBUS_SOLVE converts the bus_data csv into the PQbus array
%CSV Format 
%columns: 
%    ID, P, Q, V, Type

bus_tab = readtable(csvname);
bus_data  = table2array(bus_tab);
bus_data_size = size(bus_data);
PQbus = zeros(bus_data_size(1),2);

% fill the first column with the apparent power 
% fill the second column with the bus type
% 1 = PV, 2 = PQ
for i = 1:bus_data_size(1)
    PQbus(i,1) = complex(bus_data(i,2),bus_data(i,3));
    PQbus(i,2) = bus_data(i,5);
end

end

