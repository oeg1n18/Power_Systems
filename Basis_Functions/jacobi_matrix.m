function [X] = jacobi_matrix(A, b, prec)
    Xold = zeros(size(b));
    Xnew = zeros(size(b));
    D = diag(diag(A));
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

