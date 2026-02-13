%%% Simulation of two bodies connected by non-Hookean material in 2D
%% Coordinates (t, y, z)

%% Constants
ma = 0.1;  % kg: mass object a
mb = 0.1;  % kg: mass object b
g = 9.8;   % N/kg: gravitational acceleration
ln = 0.5;  % m: natural length
k = 0.5;   % N/m: spring constant

%% Initial conditions
t = 0;             % s: initial time
ra = [-0.3, 0.3];  % m: initial position object a
rb = [0, 0];       % m: initial position object b
va = [1, 5];       % m/s: initial velocity object a
vb = [0, 5];       % m/s: initial velocity object b

%% Boundary conditions
Ga = -ma * g * [0, 0];	% N: gravity supply object a
Gb = -mb * g * [0, 0];  % N: gravity supply object b

%% Parameters for time loop
t1 = 10;     % s: final time
dt = 0.001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
figure
plot(ra(1), ra(2), 'o', 'color', '#4477AA')
hold on; grid on
plot(rb(1), rb(2), 's', 'color', '#EE6677')
xlabel('{\it y}/m'); ylabel('{\it z}/m') %@

%% State: ra, rb, va, vb
%% Numerical time integration
while t < t1
  %% constitutive relations
  Pa = ma * va;
  Pb = mb * vb;
  l = norm(ra - rb); % calculation of present length
  if l < ln
    Fa = [0, 0];
  else
    Fa = -k * (l - ln) * (ra - rb)/l;
  end
  Fb = -Fa; % balance of momentum for non-Hookean material

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
    plot(ra(1), ra(2), 'o', 'color', '#4477AA')
    plot(rb(1), rb(2), 's', 'color', '#EE6677')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
