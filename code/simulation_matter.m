%%% Numerical simulation for amount of substance in volume

%% Initial values
t = 0; % s: initial time
N = 10; % mol: amount of substance

%% Boundary conditions
J = 4; % mol/s: net influx, constant
A = 0; % net/s: net supply, constant

%% Parameters for time loop
t1 = 2; % s: final time
dt = 0.01; % s: time step

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
clf;
plot(t, N, 'b.')
xlim([0, t1]);
ylim([5, 20]);
xlabel('time t/s');
ylabel('amount N/mol');
grid on;
hold on;

%% numerical time integration
while t < t1
    N = N + (J + A) * dt;
    t = t + dt;

  %% plot
  if t > tplot;
    plot(t, N, '.b')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end

