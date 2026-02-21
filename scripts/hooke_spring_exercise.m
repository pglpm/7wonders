%%% Simulation of two bodies connected by Hookean material in 2D
%% Coordinates (t, x, z)

%% Constants
ma = 2;	  % kg: mass object a
g = 9.8;  % N/kg: gravitational acceleration
k = 5;	  % N/m: spring constant

%% Initial conditions
t = 0;	       % s: initial time
ra = 0;  % m: initial position object a
va = 10;  % m/s: initial velocity object a

%% Boundary conditions
Ga = -ma * g;  % N: gravity supply object a
rb = 0; % m: point of attachment

%% Parameters for time loop
t1 = 10;	      % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
figure
plot(t, ra, 's', 'color', '#4477AA')
hold on; grid on
xlabel('{\it t}/s'); ylabel('{\it z}/m') %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  Pa = ma * va;
  Fa = -k * (ra - rb);

  %% balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;

  %% constitutive relations
  va = Pa / ma; %@

  %% plot
  if t > tplot
    plot(t, ra, 's', 'color', '#4477AA')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
