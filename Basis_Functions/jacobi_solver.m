function [X] = jacobi_solver(A,b)
x = zeros(size(b));
n=size(x,1);
normVal=Inf; 
%% 
% * _*Tolerence for method*_
tol=1e-3; itr=0;
%% Algorithm: Jacobi Method
%%
while normVal>tol
    xold=x;
    
    for i=1:n
        sigma=0;
        
        for j=1:n
            
            if j~=i
                sigma=sigma+A(i,j)*x(j);
            end
            
        end
        
        x(i)=(1/A(i,i))*(b(i)-sigma);
    end
    
    itr=itr+1;
    normVal=abs(xold-x);
end
%%
X = x;

    

