
% Constants
m = 0.06;
g = 9.8;

% initial conditions
r = [0, 0 ,5];
P = m * [0, 0, 10];

% boundary conditions
F = [0, 0, 0];
G = m * g * [0, 0, -1];

% time-loop parameters
t1 = 3;
dt = 0.01;


while t < t1

  v = P / m;

  t = t + dt;
  P = P + (F + G) * dt;
  r = r + v * dt;

end

