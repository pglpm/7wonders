%%% Numerical simulation of object motion with gravity
%% Coordinates (t, x, y, z)

%% Constants
m = 0.06; % kg: tennis ball's mass-energy
g = 9.8; % N/kg: gravitational acceleration

%% Initial conditions
t = 0; % s: initial time
r = [0, 0, 5]; % m: initial position vector
P = [0, 0, 0.42]; % N s: initial momentum vector

%% Boundary conditions
F = [0, 0, 0]; % N: momentum influx
G = -m * g * [0, 0, 1]; % N: momentum supply

%% Time-iteration parameters
t1 = 2; % s: final time
dt = 0.01; % s: time step %@

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
clf;
subplot(2, 1, 1); plot(t, P(3), '.b')
xlim([0, t1])
xlabel('time t/s'); ylabel('z-momentum P_z/(Ns)')
axis('tight'); grid on; hold on
subplot(2, 1, 2); plot(t, r(3), '.r')
xlim([0, t1])
xlabel('time t/s'); ylabel('z-coord z/m')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  v = P / m;

  %% step forward in time with balance laws
  t = t + dt;
  P = P + (F + G) * dt;
  r = r + v * dt; %@

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, P(3), '.b')
    subplot(2, 1, 2); plot(t, r(3), '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
