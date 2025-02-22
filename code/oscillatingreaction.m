%%% Numerical time integration of imaginary chemical reaction

%% Constants
lambda = 6.283; % s^-1: conversion rate

%% Initial conditions
t = 0; % s: initial time
Nu = 2; % mol: volume content substance u
Nv = 3; % mol: volume content substance v

%% Boundary conditions
Ju = 0; % mol/s: influx substance u
Jv = 0; % mol/s: influx substance v

%% Time-iteration parameters
t1 = 5; % s: duration of time integration
dt = 0.0001; % s: time step %@

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
clf;
plot(t, Nu, 'ob')
xlim([0, t1]);
xlabel('time t/s');
ylabel('amount N/mol');
grid on;
hold on;
plot(t, Nv, 'sr') %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  Au = -lambda * Nv;
  Av = lambda * Nu;

  %% step forward in time with balance laws
  t = t + dt;
  Nu = Nu + (Ju + Au) * dt;
  Nv = Nv + (Jv + Av) * dt; %@

  %% plot
  if t > tplot
    plot(t, Nu, 'ob')
    plot(t, Nv, 'sr')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
