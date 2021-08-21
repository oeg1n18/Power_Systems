

% general formula of euler equation
% dx/dt = f(x)
% dx/dt = 3x+0.001

t = linspace(0,0.85,86);
delta_t = 0.01;
X = zeros(size(t));


for i = 1:85
    X(i+1) = X(i) + (3*X(i)+0.1)*delta_t
    t(i) = t(i)
end



for i = 1:86
    x = 3*t(i)+0.1;
end


hold on 
plot(t,X)
plot(t,x);
hold off