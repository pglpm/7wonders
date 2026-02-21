%%% Simulation of two bodies connected by Hookean material in 2D
%% Coordinates (t, x, z)

%% Constants
ma = 5;             % kg: mass object a
g = 9.8;            % N/kg: gravitational acceleration
R = 8.31446261815;  % J/(K*mol): molar gas constant
N = 0.04;           % mol: amount of ideal gas
T = 273.15 + 23;    % K: temperature of gas

%% Initial conditions
t = 0;	   % s: initial time
ra = 1.8;  % m: initial position object a
va = 0;    % m/s: initial velocity object a

%% Boundary conditions
Ga = -ma * g;  % N: gravity supply object a

%% Parameters for time loop
t1 = 10;      % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
clf
plot(t, ra, 's', 'color', '#CCBB44')
xlabel('{\it t}/s'); ylabel('{\it r_a}/m')
hold on; axis('tight'); xlim([0, t1]); grid on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  Pa = ma * va;
  Fa = R * N * T / ra;

  %% balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;

  %% constitutive relations
  va = Pa / ma; %@

  %% plot
  if t > tplot
    plot(t, ra, 's', 'color', '#CCBB44')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
