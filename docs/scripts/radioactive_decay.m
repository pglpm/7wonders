%%% Time integration of radioactive decay

%% Constants
lambda = 0.000122;  % 1/yr: decay constant for C14

%% Initial conditions
t = 0;      % s: initial time
N = 1e-12;  % mol: initial amount of C14

%% Boundary conditions
J = 0;  % mol/s: matter influx of C14

%% Parameters for time loop
t1 = 20000;  % yr: final time
dt = 1;      % yr: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
figure
plot(t, N, 'o', 'color', '#4477AA')
xlabel('{\it t}/s'); ylabel('{\it N}/mol')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  R = -lambda * N;

  %% step forward in time with balance law
  t = t + dt;
  N = N + (J + R) * dt; %@

  %% plot
  if t > tplot
    plot(t, N, 'o', 'color', '#4477AA')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
