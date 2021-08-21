function [Vbus] = getVbus(csvname)
%GETVBUS Summary of this function goes here
%   Detailed explanation goes here
bus_tab = readtable(csvname);
bus_data  = table2array(bus_tab);
bus_data_size = size(bus_data);

Vbus = ones(bus_data_size(1), 1);

    for i = 1:bus_data_size(1)
        Vbus(i) = bus_data(i,4);
    end


end
