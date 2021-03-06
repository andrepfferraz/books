function dx = gillespie_ode(t,x,c)
dx=zeros(4,1);
dx(1) = c(6)*(x(2)^2)/2 - c(5)*x(1)*x(2);
dx(2) = c(2)*x(3) + 2*c(4)*x(4) + c(5)*x(1)*x(2) - c(1)*x(2) - c(3)*(x(2)^2)-c(6)*(x(2)^2)/2;
dx(3) = c(1)*x(2) - c(2)*x(3);
dx(4) = c(3)*(x(2)^2)/2 - c(4)*x(4);