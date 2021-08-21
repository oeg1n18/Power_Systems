classdef Buses
    %BUSES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Bus_objs = Bus;
    end
    
    methods
        function obj = Buses(inputArg1,inputArg2)
            %BUSES Construct an instance of this class
            %   Detailed explanation goes here
            busdata = readtable('busdata.csv');
            busdata = table2array(busdata);
            busdata_size = size(busdata);
            for i = 1:busdata_size(1)
                obj.Bus_objs(i) = Bus(busdata(i,1), busdata(i,2), busdata(i,3), busdata(i,4), busdata(i,5), busdata(i,6), busdata(i,7), busdata(i,8), busdata(i,9), busdata(i,10));
            end
        end
        
 
    end
end

