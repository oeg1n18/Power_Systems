function [X] = gaus_seidel_solver(A,b, prec)
    Xold = zeros(size(b));
    Xnew = zeros(size(b));
    D = tril(A);
    D_inv = inv(D);
    DA = (D - A);
    M = mtimes(D_inv, DA);
    error = Inf;
    
    while error > prec
        Xold = Xnew;
        Xnew = (mtimes(M,Xold) + mtimes(D_inv,b));
        error = abs(Xold-Xnew);

    end
    
    X = Xnew


end

