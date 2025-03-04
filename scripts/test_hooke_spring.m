%%% Simulation of two bodies connected by Hookean material in 2D
%% Coordinates (t, y, z)
clear
%% Constants
ma = 2;	   % kg: mass of object a
mb = 4;	   % kg: mass of object b
g = 0*9.81;  % N/kg: gravitational acceleration
ln = 1;	   % m: natural length
k = 5;	   % N/m: spring constant

%% Initial conditions
t = 0;	       % s: initial time
ra = [-3, 0];  % m: initial position of object a
rb = [3, 0];   % m: initial position of object b
va = [0, 10];  % m/s: initial velocity of object a
vb = [0, -10]*ma/mb;   % m/s: initial velocity of object b

%% Boundary conditions
Ga = -ma * g * [0, 1];  % N: gravity supply on object a
Gb = -mb * g * [0, 1];  % N: gravity supply on object b

%% Parameters for time loop
t1 = 5;	     % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
figure
plot(ra(1), ra(2), 'sb')
hold on; grid on
plot(rb(1), rb(2), 'or')
xlabel('{\it y}/m'); ylabel('{\it z}/m') %@

%% State: ra, rb, va, vb
%% Numerical time integration
while t < t1
  %% constitutive relations
  Pa = ma * va;
  Pb = mb * vb;
  l = norm(ra - rb); % calculation of present length
  Fa = -k * (l - ln) * (ra - rb)/l;
  Fb = -Fa; % balance of momentum for Hookean material

  %% balances
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  Pb = Pb + (Fb + Gb) * dt;
  ra = ra + va * dt;
  rb = rb + vb * dt;

  %% constitutive relations
  va = Pa / ma;
  vb = Pb / mb; %@

  %% plot
  if t > tplot
    plot(ra(1), ra(2), 'sb')
    plot(rb(1), rb(2), 'or')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
