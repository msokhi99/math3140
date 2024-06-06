% Solving a PDE using FDM :

l = 1;
x = 0 :0.1 :l;
t = 0:0.1:l;
N = 10;
y = t;

% Stepsize :

dx = 0.1;
dt = 0.1;
phi = zeros(11,11);

% Initial Boundary Conditions :

phi(:,1) = 0;
phi(:,11) = 0;
phi(l,:) = sin(pi.*x/l);
z = sin(2*pi.*y/l)+ sin(pi.*x/l);

% Initial Conditions for Phi :
for i = 2:10
    phi(2, i) = 0.5*(phi(1, i+1) + phi (1, i-1));
end

for j = 2:10
    for i = 2:10
        phi(j+1, i) = phi(j, i+1)+ phi(j, i-1)- phi(j-1, i);
    end
end

% Initial Conditions for Z :

for i = 2:10
    z(2, i) = 0.5*(z(1, i+1) + z (1, i-1));
end

for j = 2:10
    for i = 2:10
        z(j+1, i) = z(j, i+1)+z(j, i-1)-z(j-1, i);
    end
end

% Plots :

figure
surf(x,t,phi)
axis([0 1 0 1 -1 1])
xlabel('X distance')
ylabel('Time ')
zlabel('Value of Phi')
title ('Wave function as a function of time and distance: ');

figure
surf(y,t,z)
axis([0 1 0 1 -1 1])
xlabel('Y distance')
ylabel('Time ')
zlabel('Value of Z')
title ('Wave function as a function of time and distance: ');
