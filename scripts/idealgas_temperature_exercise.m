%%% Simulation of ideal gas & piston
%% Coordinates (t, z)

%% Constants
m = 20;             % kg: mass piston
g = 9.8;            % N/kg: gravitational acceleration
R = 8.31446261815;  % N m/(K*mol): molar gas constant
N = 0.02;           % mol: amount of ideal gas
C = 20;             % J/(K mol): molar heat capacity

%% Initial conditions
t = 0;	  % s: time
z = 0.1;  % m: position piston
v = 0;    % m/s: velocity piston
T = 298.15;  % K: temperature of ideal gas

%% Boundary conditions, state: (z, v)
G = -m * g;  % N: gravity supply piston
Q = 0;       % J/s: heat flux

%% Parameters for time loop
t1 = 5;        % s: final time
dt = 0.00001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;	  % time for next plot
clf
subplot(2, 1, 1); plot(t, z, 's', 'color', '#CCBB44')
xlabel('{\it t}/s'); ylabel('{\it z}/m')
hold on; axis('tight'); xlim([0, t1]); grid on
subplot(2, 1, 2); plot(t, T, '*', 'color', '#EE6677')
xlabel('{\it t}/s'); ylabel('{\it T}/K')
hold on; axis('tight'); xlim([0, t1]); grid on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  P = m * v;
  F = R * N * T / z;
  E = C * N * T;
  Phi = Q + dot(-F, v);

  %% balance laws
  t = t + dt;
  P = P + (F + G) * dt;
  z = z + v * dt;
  E = E + Phi * dt;

  %% constitutive relations: find new state
  v = P / m;
  T = E / (C * N); %@

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, z, 's', 'color', '#CCBB44')
    subplot(2, 1, 2); plot(t, T, '*', 'color', '#EE6677')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
