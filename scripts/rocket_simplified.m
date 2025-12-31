%%% Numerical simulation of rocket propulsion
%% Coordinates (t, z)

%% Constants
%2900000 kg total
%2145798 kg fuel stage I
%1499479 kg LOX
%646318 kg RP-1
%792516 kg total without fuel I
%0.19822 g/molRP-1 molar mass
%0.219 kg/mol LOX/RP-1
%2.6e3 kg/s mass flow * 5 = 1.3e4 kg/s -> 1.1e4 mol/s * 5 = 6e5 mol/s
%9753627 mol fuel
%6.8e6 N * 5 thrust sea level = 3.4e7 N thrust sea level
%4000000 N/m^2 pressure
%vb = 2.5 km/s at start?
% 3200 or 1600 K temp ->
% 150 or 300 mol/m^3
% 0.3 drag coef
%113 m^2 drag area
% max vel should be 1620 m/s
m = 7.9e5;         % kg: rocket mass without fuel
rho = 0.22;        % kg/mol: fuel molar mass
delta = 0.46;            % mol/m^3: fuel molar density
A = 50;           % m^2: nozzle area
g = 9.8;      % kg: free-fall acceleration

%% Initial conditions
t = 0;       % s: initial time
N = 9.8e6;  % mol: amount of fuel
z = 0;       % m: altitude of control volume
v = 0;       % m/s: velocity of control volume

%% Boundary conditions
J = -6e4;  % mol/s: matter influx at nozzle
p = 4e6 - 1e5;  % N/m^2: pressure at nozzle
Sigma = A * p;

%% Time-iteration parameters
t1 = 130;    % s: final time
dt = 0.001;  % s: time step

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
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
  F = Sigma + J * rho * vb - 113 * 0.35 * abs(v) * v / 2;
  G = -(m + rho * N) * g;

  t = t + dt;
  N = N + J * dt;
  P = P + (F + G) * dt;
  z = z + v * dt;

  v = P / (m + rho * N);

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, z, '.b')
    subplot(2, 1, 2); plot(t, v, '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@

end
