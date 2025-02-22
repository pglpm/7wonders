%%% tennisball_simple.m
%% Numerical simulation of object motion in 2D with gravity
%% (base SI units used throughout)
%% Coordinates (y,z)
m = 0.06;
g = 9.8;

y = 0;
z = 3;
vy = 1;
vz = 10;

Py = m * vy;
Pz = m * vz;

t = 0;
t_end = 3;
dt = 0.01;



Fy = 0;
Fz = 0;
Gy = 0;
Gz = -m * g;

clf;
plot(y, z, '.')
hold on

while t < t_end

y = y + vy * dt;
z = z + vz * dt;

Py = Py + (Fy + Gy) * dt;
Pz = Pz + (Fz + Gz) * dt;

t = t + dt;

vy = Py/m;
vz = Pz/m;

plot(y, z, '.') % plot trajectory

end

y
z
vy
vz
