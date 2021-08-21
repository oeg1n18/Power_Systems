classdef Trans < Line
    %TRANS_LINES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Lines = Line;
        N;
        Ybus;
    end
    
    methods
        function obj = Trans()
            %TRANS_LINES Construct an instance of this class
            %   Detailed explanation goes here
            Z_data = readtable('Z_data.csv');
            Z_data = table2array(Z_data);
            
            imp_size = size(Z_data);
            obj.N = imp_size(1);
            
            
               for i = 1:obj.N
                   for j = 1:obj.N
                       Z_real = real(Z_data(i,j));
                       Z_react = imag(Z_data(i,j));
                       obj.Lines(i,j) = Line(i,j,Z_real, Z_react);
                   end
               end
               
             obj.Ybus = obj.calc_Ybus();
        end
       
         
        
        
        function Ybus = calc_Ybus(obj)
            
            Y = zeros(obj.N(1),obj.N);
            
            for i = 1:obj.N
                for j = 1:obj.N
                    if i ~= j
                        Y(i,j) = -obj.Lines(i,j).Y;
                    elseif abs(Y(i,j)) == Inf
                         Y(i,j) = 0;
                    elseif i == j 
                        self_admitt = 0;
                        for iter = 1:obj.N
                            if abs(obj.Lines(i,iter).Y) ~= Inf
                                self_admitt = self_admitt + obj.Lines(i,iter).Y;
                            end
                        end
                        Y(i,j) = self_admitt;
                    end
                end
            end
            Ybus = Y;
        end
    end
end

