%%% Simulation of ideal gas & piston
%% Coordinates (t, z)

%% Constants
ma = 5;             % kg: mass piston
g = 9.8;            % N/kg: gravitational acceleration
R = 8.31446261815;  % N m/(K*mol): molar gas constant
N = 0.04;           % mol: amount of ideal gas
T = 296;            % K: temperature of ideal gas

%% Initial conditions
t = 0;	   % s: time
ra = 1.8;  % m: position piston
va = 0;    % m/s: velocity piston

%% Boundary conditions
Ga = -ma * g;  % N: gravity supply piston

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
