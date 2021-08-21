function [sol] = newtonraphson(F, x0, maxiter)

for i = x0
    syms i
end

J = jacobian(F, x0);
