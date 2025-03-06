%%% Numerical simulation of object motion with gravity
%% Coordinates (t, x, y, z)

%% Constants
ma = 0.06; % kg: mass-energy object a
mb = 0.06; % kg: mass-energy object b
g = 9.8; % N/kg: gravitational acceleration

%% Initial conditions
t = 0; % s: initial time
ra = [0, 0, 10]; % m: initial position vector a
rb = [0, 0, 5]; % m: initial position vector b
Pa = [0, 0, -0.5]; % N s: initial momentum vector a
Pb = [0, 0, 0.5]; % N s: initial momentum vector b

%% Boundary conditions
Fa = [0, 0, 0]; % N: momentum influx object a
Fb = [0, 0, 0]; % N: momentum influx object b
Ga = -ma * g * [0, 0, 1]; % N: momentum supply object a
Gb = -mb * g * [0, 0, 1]; % N: momentum supply object b

%% Time-iteration parameters
t1 = 2; % s: final time
dt = 0.00001; % s: time step %@

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
figure
plot(t, ra(3), 'ob')
xlim([0, t1])
axis('tight'); grid on; hold on
plot(t, rb(3), 'sr')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it z}/m')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  va = Pa / ma;
  vb = Pb / mb;

  %% step forward in time with balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;
  Pb = Pb + (Fb + Gb) * dt;
  rb = rb + vb * dt; %@

  %% plot
  if t > tplot
    plot(t, ra(3), 'ob')
    plot(t, rb(3), 'sr')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
