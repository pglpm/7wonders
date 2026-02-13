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
figure
subplot(2, 1, 1); plot(t, P(3), '^', 'color', '#4477AA')
xlabel('time {\it t}/s'); ylabel('z-momentum {\it P_z}/(N s)')
axis('tight'); xlim([0, t1]); grid on; hold on
subplot(2, 1, 2); plot(t, r(3), 'o', 'color', '#EE6677')
xlabel('time {\it t}/s'); ylabel('coordinate {\it z}/m')
axis('tight'); xlim([0, t1]); grid on; hold on %@

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
    subplot(2, 1, 1); plot(t, P(3), '^', 'color', '#4477AA')
    subplot(2, 1, 2); plot(t, r(3), 'o', 'color', '#EE6677')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
