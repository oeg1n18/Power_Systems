
t = linspace(0, 6*pi/50, 300);

e_fA = zeros(300);
e_fB = zeros(300);
e_fC = zeros(300);

for ind = 1:300
    current_time = t(ind);
    [e1, e2, e3] = ss_non_salient_noload_gen(current_time, 3, 10, 10, 30,50);
    e_fA(ind) = e1;
    e_fB(ind) = e2;
    e_fC(ind) = e3;
    
  
end
hold on
plot(t, e_fA)
plot(t, e_fB)
plot(t, e_fC)
hold off
    
    