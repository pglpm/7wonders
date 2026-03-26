%%% Simulation of ideal gas, spring, mass
%% Coordinates (t, x, z)

%% Constants
g = 9.8;          % N/kg: acceleration of free fall
R = 8.314462;     % N m/(K mol): molar gas constant
m = 10;           % kg: mass of object
rg1 = [-0.2, 0];  % m: position fixed-end gas 1
rg2 = [0.2, 0];   % m: position fixed-end gas 2
N = 0.01;         % mol: amount of each ideal gas
C = 20;           % J/(K mol): molar heat capacity
h = 1000;         % J/(s K m^2): heat-transfer coeff.
A = 0.02^2;       % m^2: base area of cylinders
Tout = 298.15;    % K: external temperature

%% Initial conditions, state: (r, v, T1, T2)
t = 0;         % s: time
r = [0, 0.1];  % m: position object
v = [0, 0];    % m/s: velocity object
T1 = 298.15;   % K: temperature gas 1
T2 = 298.15;   % K: temperature gas 2

%% Boundary conditions
G = -m * g * [0, 1];  % N: momentum supply object

%% Parameters for time loop
t1 = 5;        % s: final time
dt = 0.00001;  % s: time step

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
subplot(3, 1, 1);
plot(r(1), r(2), 'o', 'color', '#000000'); hold on
plot([rg1(1), r(1)], [rg1(2), r(2)], '-', 'color', '#66CCEE')
plot([rg2(1), r(1)], [rg2(2), r(2)], '-', 'color', '#66CCEE')
xlim([-0.7, 0.7]); ylim([-0.7, 0.7]); axis('equal')
xlabel('{\it x}/m'); ylabel('{\it z}/m'); grid on
subplot(3, 1, 2); plot(t, T1, '*', 'color', '#EE6677')
xlabel('{\it t}/s'); ylabel('{\it T_1}/K')
axis('tight'); xlim([0, t1]); grid on; hold on
subplot(3, 1, 3); plot(t, T2, '*', 'color', '#AA3377')
xlabel('{\it t}/s'); ylabel('{\it T_2}/K')
axis('tight'); xlim([0, t1]); grid on; hold on

%% Numerical time integration
while t < t1
  %% useful quantities to calculate beforehand
  Lg1 = norm(r - rg1);  % length cylinder gas 1
  V1 = A * Lg1;         % volume gas 1
  Lg2 = norm(r - rg2);  % length cylinder gas 2
  V2 = A * Lg2;         % volume gas 2

  %% constit. relations & principles
  %% force on object from gas 1
  Fg1 = A * (R * N * T1 / V1) * (r - rg1) / Lg1;
  %% force on object from gas 2
  Fg2 = A * (R * N * T2 / V2) * (r - rg2) / Lg2;
  %% total force on object
  F = Fg1 + Fg2;
  P = m * v;
  %% heat flux from gas 2 to gas 1
  Q1 = A * h * (T2 - T1);
  %% energy flux into gas 1
  Phi1 = Q1 + dot(-Fg1, v);
  E1 = C * N * T1;
  %% heat flux from gas 1 to gas 2
  Q2 = A * h * (T1 - T2);
  %% energy flux into gas 2
  Phi2 = Q2 + dot(-Fg2, v);
  E2 = C * N * T2;

  %% step forward in time with balance laws
  t = t + dt;
  P = P + (F + G) * dt;
  E1 = E1 + Phi1 * dt;
  E2 = E2 + Phi2 * dt;
  r = r + v * dt;

  %% constit. relations: find new state variables
  v = P / m;
  T1 = E1 / (C * N);
  T2 = E2 / (C * N);

  %% plot
  if t > tplot
    subplot(3, 1, 1); cla
    plot(r(1), r(2), 'o', 'color', '#000000');
    plot([rg1(1), r(1)], [rg1(2), r(2)], '-', 'color', '#66CCEE')
    plot([rg2(1), r(1)], [rg2(2), r(2)], '-', 'color', '#66CCEE')
    subplot(3, 1, 2); plot(t, T1, '*', 'color', '#EE6677')
    subplot(3, 1, 3); plot(t, T2, '*', 'color', '#AA3377')
    pause(0)
    tplot = tplot + dtplot;
  end
end
