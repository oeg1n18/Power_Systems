function [V2,I2] = non_ideal_trans(R1 ,X1, Gc, Bm, R2, X2, N1, N2, V1, I1)

ref = (N1/N2)^2;

A1 = [1 complex(R1, X1); 0 1];
A2 = [1 0; Gc 1];
A3 = [1 0; complex(1, -Bm) 1];
A4 = [1 complex(ref*R2, ref*X2); 0 1];

A = A1.*A2.*A3.*A4;

X = [V1; I1];

Y = X.*A;
V2 = Y(1,1);
I2 = Y(1,2);

end

