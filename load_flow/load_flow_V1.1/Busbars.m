classdef Busbars < Bus;
    %BUSES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Buses = Bus;
        M;
    end
    
    methods
        function obj = Busbars()
            %BUSES Construct an instance of this class
            %   Detailed explanation goes here
            busdata = readtable('busdata.csv');
            busdata = table2array(busdata);
            busdata_size = size(busdata);
            for i = 1:busdata_size(1)
                obj.Buses(i) = Bus(busdata(i,1), busdata(i,2), busdata(i,3), busdata(i,4), busdata(i,5), busdata(i,6), busdata(i,7), busdata(i,8));
            end
            
            tot_buses = busdata_size(1);
            count = 0;
            for i = 1:busdata_size(1)
                if obj.Buses(i).type == 3
                    count = count + 1;
                end
            end
            obj.M = tot_buses - count -1;
        end
        
    end
end

