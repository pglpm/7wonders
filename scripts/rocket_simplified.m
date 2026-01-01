%%% Numerical simulation of rocket propulsion
%% Coordinates (t, z)

%% Constants
m = 7.9e5;    % kg: rocket mass without fuel
rho = 0.22;   % kg/mol: fuel molar mass
delta = 0.5;  % mol/m^3: fuel molar density
A = 50;       % m^2: nozzle area
g = 9.8;      % kg: free-fall acceleration

%% Initial conditions
t = 0;      % s: initial time
N = 9.8e6;  % mol: amount of fuel
z = 0;      % m: altitude of control volume
v = 0;      % m/s: velocity of control volume

%% Boundary conditions
J = -6e4;           % mol/s: matter influx at nozzle
patm = 1e5;         % N/m^2: atmospheric pressure
p = 5e4;            % N/m^2: pressure at nozzle
Fatm = -A * patm;  % N: force on rocket surface
Sigma = A * p;      % N: stress tensor at nozzle

%% Time-iteration parameters
t1 = 150;    % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
figure
subplot(2, 1, 1); plot(t, z, '.b')
xlim([0, t1])
xlabel('time {\it t}/s'); ylabel('{\it z}/m')
axis('tight'); grid on; hold on
subplot(2, 1, 2); plot(t, v, '.r')
xlim([0, t1])
xlabel('time {\it t}/s'); ylabel('{\it v} / (m/s)')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1 && N > 0 % '&&' means 'and'

  P = (m + rho * N) * v;
  vb = v + J / (A * delta);
  F = Fatm + Sigma + J * rho * vb;
  G = -(m + rho * N) * g;

  t = t + dt;
  N = N + J * dt;
  P = P + (F + G) * dt;
  z = z + v * dt;

  v = P / (m + rho * N); %@

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, z, '.b')
    subplot(2, 1, 2); plot(t, v, '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
