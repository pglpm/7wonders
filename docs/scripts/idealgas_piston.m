%%% Simulation of ideal gas & mass piston in 1D
%% Coordinates (t, z)

%% Constants
R = 8.31446261815;   % J/(K*mol): molar gas constant
g = 9.8;             % N/kg: gravitational acceleration
C = 20;              % J/(K*mol): molar heat capacity
mu = 4e-5;           % N*s/m^2: gas viscosity
h = 8e3;             % J/(K*m^2): heat-transfer coefficient
N = 0.04;            % mol: amount of ideal gas
A = 0.1^2;           % m^2: area of piston
m = 10;              % kg: mass of piston

%% Initial conditions. State: (z, v, T)
t = 0;            % s: initial time
z = 0.15;         % m: initial position of piston
v = 0;            % m/s: initial velocity of piston
T = 273.15 + 23;  % K: initial temperature of gas

%% Boundary conditions
Gpis = -m*g;         % N: gravity supply of momentum to piston
Fatm = -1e5 * A;     % N: force on piston by atmosphere
Text = 373.15 + 23;  % K: temperature of environment
                     % other fluxes are zero

%% Parameters for time loop
t1 = 1;       % s: final time
dt = 0.0001;  % s: time step %@

## Plotting
dtplot = t1/360; # time interval between plots
tplot = dtplot; # time for next plot
figure
subplot(2, 1, 1); plot(t, z, '.b')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it z}/m')
axis('tight'); grid on; hold on
subplot(2, 1, 2); plot(t, T, '.r')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it T}/K')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  Fgas = -(R * N * T / z -  mu * A * v / z);
  Fpis = -Fgas + Fatm;
  Ppis = m * v;
  Qbot = A * h * (Text - T);
  Qtop = Fgas * v;
  Phi = Qbot + Qtop;
  E = C * N * T;

  %% step forward in time with balance laws
  t = t + dt;
  Ppis = Ppis + (Fpis + Gpis) * dt;
  z = z + v * dt;
  E = E + Phi * dt;

  %% constitutive relations: calculate state
  T = E / (C * N);
  v = Ppis / m;  %@

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, z, '.b')
    subplot(2, 1, 2); plot(t, T, '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
