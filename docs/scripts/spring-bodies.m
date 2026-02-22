%%% 2D simulation of two bodies connected by Hookean material
%% Coordinates (x, z)

%% 0. Constants
ma = 2;   % kg: mass of object a
mb = 2;   % kg: mass of object b
g = 9.8;  % N/kg: gravitational acceleration
k = 5;    % N/m: spring constant

%% 2. State variables and initial conditions
t = 0;         % s: initial time
ra = [-3, 0];  % m: initial position of object a
rb = [3, 0];   % m: initial position of object b
va = [0, 10];  % m/s: initial velocity of object a
vb = [0, 0];   % m/s: initial velocity of object b

%% 3. Boundary conditions
Ga = -ma * g * [0, 1];  % N: gravity supply in object a
Gb = -mb * g * [0, 1];  % N: gravity supply in object b

%% 6. Parameters for time integration
t1 = 5;      % s: final time
dt = 0.0001;  % s: time step

%% Numerical time integration
while t < t1

  %% 4. Calculate forward-driving quantities from state
  Pa = ma * va;
  Pb = mb * vb;
  Fa = -k * (ra - rb);
  Fb = -Fa;  % balance of momentum for Hookean material

  %% 1. Balances drive forward in time
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  Pb = Pb + (Fb + Gb) * dt;
  ra = ra + va * dt;
  rb = rb + vb * dt;

  %% 5. Calculate new state from forward-driven quantities
  va = Pa / ma;
  vb = Pb / mb;

end
