%%% Numerical time integration of dampened fall
%% vertical z coordinate, positive upward
%% SI base units used throughout
m = 100; % mass
z0 = 0; % initial position
v0 = -4.4272; % initial velocity
k = 1500; % elastic constant
h = 1000; % viscosity coefficient
g = 9.8; % gravitational acceleration
t0 = 0; % initial time
dt = 0.01; % time step
%% Numerical time integration
%% Initialize
t = t0;
z = z0;
v = v0;
P = m*v0; % initial momentum
G = -m*g; % constant momentum supply
%% stop when |v| < 1 mm/s
while (abs(v) > 0.001)
  t = t + dt;
  F = -k*z - h*v;
  P = P + (F + G)*dt;
  z = z + v*dt;
  v = P/m;
end
disp(z)
disp(t)
