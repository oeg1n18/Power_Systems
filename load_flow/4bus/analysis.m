

PQbus = getPQbus('bus.csv');
Vbus= getVbus('bus.csv');
Y_bus = getYbus('admittance.csv')

Vbus_size = size(Vbus);








Vbusold = ones(Vbus_size(1),1);

for V = 1:5000
    
    for k = 1:Vbus_size(1); 
        sum = 0;
        
        if PQbus(k,2) == 2
            for n = 1:Vbus_size(1); 
                if k ~= n
                    sum = sum + Y_bus(k,n)*Vbus(n);
                end
            end
            bus_data(k,4) = (1/Y_bus(k,k))*(conj(PQbus(k,1))/Vbusold(k) - sum);
            sum = 0;
        
        % =================== PV bus calculation ========================
        elseif PQbus(k,2) == 1 
            sum = 0;
            for n = 1:Vbus_size(1);
                if n ~= k
                    sum = sum + Y_bus(k,n)*Vbus(n,1);
                end
            end
            
            Qnew = imag(-(conj(Vbus(k))*sum));
            sum = 0;
            
            PQbus(k) = complex(real(PQbus(k)), Qnew);
            
            % can now find the voltage of the PV bus 
            for n = 1:Vbus_size(1)
                if n~=k
                    sum = sum + Y_bus(k,n)*Vbus(n);
                end
                Vbus(k) = (1/Y_bus(k,k))*((conj(PQbus(k))/Vbusold(k)) - sum);
                sum = 0;
            end
        end
            
            
    end
    Vbusold(k) = Vbus(k);
    
    Vbus_polar = ones(Vbus_size(1), Vbus_size(2));
    for q = 1:Vbus_size(1)
        Vbus_polar(q,1) = abs(Vbus(q));
        Vbus_polar(q,2) = angle(Vbus(q));
    end
    
    Vbus_polar
        
end
            
                
                    
        
       
            
             
                
         
        
            
    
   



