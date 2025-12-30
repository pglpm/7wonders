%%% Numerical simulation of rocket propulsion
%% Coordinates (t, z)

%% Constants
m = 756e3;         % kg: rocket mass without fuel
rho = 0.17;        % kg/mol: fuel molar mass
d = 25;            % mol/m^3: fuel molar density
A = 7.5;           % m^2: nozzle area
h = 0.3;           % N/(m^2/s^2): drag coefficient
ka = 6.67430e-11;  % N/(kg^2/m^2): gravity const.
ME = 5.97e24;      % kg: Earth's mass
RE = 6371e3;       % m: Earth's radius

%% Initial conditions
t = 0;       % s: initial time
N = 12.2e6;  % mol: amount of fuel
z = 0;       % m: altitude of control volume
v = 0;       % m/s: velocity of control volume

%% Boundary conditions
J = -80e3;  % mol/s: matter influx at nozzle
p = 3.7e6;  % kg/m^2: pressure at nozzle

%% Time-iteration parameters
t1 = 160;    % s: final time
dt = 0.001;  % s: time step

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
figure
subplot(2, 1, 1); plot(t, 0, '.b')
xlim([0, t1])
xlabel('time {\it t}/s'); ylabel('{\it Fconv}/N')
axis('tight'); grid on; hold on
subplot(2, 1, 2); plot(t, v, '.r')
xlim([0, t1])
xlabel('time {\it t}/s'); ylabel('{\it v} / (m/s)')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1 && v < 300 && N > 0 % '&&' means 'and'

  P = (m + rho * N) * v;
  Fside = -h * abs(v) * v;
  Fnoz = A * p + rho * J^2 / (A * d) + rho * J * v;
  F = Fnoz + Fside;
  G = -ka * (m + rho * N) * ME / (RE + z)^2;

  t = t + dt;
  N = N + J * dt;
  P = P + (F + G) * dt;
  z = z + v * dt;

  v = P / (m + rho * N);

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, Fnoz - A * p, '.b')
    subplot(2, 1, 2); plot(t, v, '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@

end
