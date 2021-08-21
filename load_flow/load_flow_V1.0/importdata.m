function [Buses, Lines] = importdata()
   busdata = readtable('busdata.csv');
   Z_data = readtable('Z_data.csv');
   
   busdata = table2array(busdata);
   Z_data = table2array(Z_data);
   
   
   imp_size = size(Z_data);
   
    
   % Populate the Lines impedance data 
   for i = 1:imp_size(1)
       for j = 1:imp_size(2)
           Z_real = real(Z_data(i,j));
           Z_react = imag(Z_data(i,j));
           Lines(i,j) = Line(i,j,Z_real, Z_react);
       end
   end
   
   
   %Populate the Bus data
   for i = 1:imp_size(1)
       Buses(i) = Bus(busdata(i,1), busdata(i,2), busdata(i,3), busdata(i,4), busdata(i,5), busdata(i,6), busdata(i,7), busdata(i,8), busdata(i,9), busdata(i,10));
   end
   

           
   
   
   
end

