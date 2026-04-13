%%% Simulation of ideal gas, band, mass
%% Coordinates (t, x, z)

%% Constants
g = 9.8;        % N/kg: acceleration of free fall
R = 8.314462;   % N m/(K mol): molar gas constant
m = 20;         % kg: mass of object
Ln = 0;         % m: natural length band
k = 500;        % N/m: elastic constant band
rB = [0, 0.5];  % m: position fixed-end band
N = 0.01;       % mol: amount of ideal gas
C = 20;         % J/(K mol): molar heat capacity
A = 0.01^2;     % m^2: base area of cylinder
rI = [0, 0];    % m: position fixed-end cylinder

%% Initial conditions, state: (r, v, T)
t = 0;           % s: time
r = [0.1, 0.3];  % m: position of object
v = [0, 0];      % m/s: velocity of object
T = 298.15;      % K: temperature of gas

%% Boundary conditions
G = -m * g * [0, 1];  % N: momentum supply
Q = 0;                % J/s: heat flux into gas

%% Parameters for time loop
t1 = 10;       % s: final time
dt = 0.00001;  % s: time step
%@
%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
subplot(2, 1, 1);
plot(r(1), r(2), 'o', 'color', '#4477AA'); hold on
plot([rI(1), r(1)], [rI(2), r(2)], '-', 'color', '#000000')
plot([rB(1), r(1)], [rB(2), r(2)], '-', 'color', '#CCBB44')
xlim([-0.2, 0.2]); ylim([0, 0.6])
xlabel('{\it x}/m'); ylabel('{\it z}/m'); grid on
subplot(2, 1, 2); plot(t, T, 'o', 'color', '#EE6677')
xlabel('{\it t}/s'); ylabel('{\it T}/K')
axis('tight'); xlim([0, t1]); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% useful quantities to calculate beforehand
  LB = norm(r - rB);  % length band
  LI = norm(r - rI);  % length cylinder
  V = A * LI;         % volume gas cylinder

  %% constit. relations & principles
  Fband = -k * (LB - Ln) * (r - rB) / LB;
  Fgas = A * (R * N * T / V) * (r - rI) / LI;
  F = Fgas + Fband;
  P = m * v;
  Phi = Q + dot(-Fgas, v);
  E = C * N * T;

  %% step forward in time with balance laws
  t = t + dt;
  P = P + (F + G) * dt;
  E = E + Phi * dt;
  r = r + v * dt;

  %% constit. relations: find new state variables
  v = P / m;
  T = E / (C * N);
%@
  %% plot
  if t > tplot
    subplot(2, 1, 1); hold off;
    plot(r(1), r(2), 'o', 'color', '#4477AA'); hold on
    plot([rI(1), r(1)], [rI(2), r(2)], '-', 'color', '#000000')
    plot([rB(1), r(1)], [rB(2), r(2)], '-', 'color', '#CCBB44')
    xlim([-0.2, 0.2]); ylim([0, 0.6]);
    xlabel('{\it x}/m'); ylabel('{\it z}/m');
    subplot(2, 1, 2); plot(t, T, 'o', 'color', '#EE6677')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
