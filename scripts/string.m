%%% Simulation of two bodies connected by Hookean material in 2D
%% Coordinates (t, x, z)

%% Constants
ma = 0.1;    % kg: mass of object
g = 9.8;     % N/kg: gravitational acceleration
l0 = 1;      % m: natural length
k = 100000;  % N/m: spring constant

%% Initial conditions
t = 0;              % s: initial time
ra = [-0.1, -0.9];  % m: initial position of object a
va = [0, 0];        % m/s: initial velocity of object a

%% Boundary conditions
Ga = -ma * g * [0, 1];  % N: gravity supply on object a

%% Parameters for time loop
t1 = 2;         % s: final time
dt = 0.000001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
figure
plot(ra(1), ra(2), 'o', 'color', '#4477AA')
hold on; grid on
xlabel('{\it x}/m'); ylabel('{\it z}/m') %@

%% State: ra, rb, va, vb
%% Numerical time integration
while t < t1
  l = norm(ra);  % calculation of present length

  %% constitutive relations
  Pa = ma * va;  % Newton's relation for momentum
  %% constitutive law for spring
  if l < l0
    Fa = 0;
  else
    Fa = -k * ra * (l - l0)/ l;
  end

  %% balances
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;

  %% constitutive relations
  va = Pa / ma; %@

  %% plot
  if t > tplot
    plot(ra(1), ra(2), 'o', 'color', '#4477AA')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
