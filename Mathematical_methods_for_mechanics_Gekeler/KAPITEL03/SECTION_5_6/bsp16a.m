function Y = bsp16(X,flag,Parmeter);
% Himmelblau, p. 395
% flag = 1: Objective function
% flag = 2: Inequalities
% flag = 3: Equalities
% flag = 4: Gradient of objective function
% flag = 5: Gradient of inequalities
% flag = 6: Gradient of equalities
% -------------------------------------------
% Gradient of f: R_n -> R_m is (m,n)-matrix
% -------------------------------------------
hh = 1E-5; % increment for calculation of derivative

c   = [-6.089; -17.164; -34.054; -5.914; -24.721;...
     -14.986; -24.100; -10.708; -26.662; -22.179];
SUM = sum(X);
AUX = real(log(X/SUM));
switch flag
case 1, Y   = X'*(c + AUX);
case 2, Y = X;
case 3
   h1 = X(1) + 2*X(2) + 2*X(3) + X(6) + X(10) - 2;
   h2 = X(4) + 2*X(5) + X(6) + X(7) - 1;
   h3 = X(3) + X(7) + X(8) + 2*X(9) + X(10) - 1;
   Y = [h1; h2; h3];
case 4, Y = derivative(@bsp16,X,1,hh,Parmeter);
case 5, Y = derivative(@bsp16,X,2,hh,Parmeter);
case 6, Y = derivative(@bsp16,X,3,hh,Parmeter);
end;
