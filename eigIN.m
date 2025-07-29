function EIGENVALUE = eigIN(A)

syms lambda; % declare lambda as a variable

I = eye(size(A)); % create identity matrix for the size of A

M = A - lambda * I; % (A-λI)

poly = det(M); % determinant matrix 

EIGENVALUE = double(solve(poly, lambda)); % solve for lambda with respect to the polynomial function (double to put in decimal form)

end