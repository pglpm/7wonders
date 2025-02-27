%%% Numerical simulation of object motion with gravity
%% Coordinates (t, x, y, z)

%% Constants
ma = 0.06; % kg: mass-energy object a
mb = 10000; % kg: mass-energy object b
g = 9.8; % N/kg: gravitational acceleration
k = 10; % elastic constant
d = 0.07; % m: distance between centres of objects

%% Initial conditions
t = 0; % s: initial time
ra = [0, 0, 5]; % m: initial position vector a
rb = [0, 0, 0]; % m: initial position vector b
Pa = [0, 0, 0]; % N s: initial momentum vector a
Pb = [0, 0, 0]; % N s: initial momentum vector b

%% Boundary conditions
Ga = -ma * g * [0, 0, 1]; % N: momentum supply object a
Gb = -mb * 0 * [0, 0, 1]; % N: momentum supply object b

%% Time-iteration parameters
t1 = 10; % s: final time
dt = 0.00001; % s: time step %@

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
figure
subplot(2, 1, 1); plot(t, ra(3), '.b')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it z_a}/m')
axis('tight'); grid on; hold on
subplot(2, 1, 2); plot(t, rb(3), '.r')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it z_b}/m')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  va = Pa / ma;
  vb = Pb / mb;
  %% const. relation for Fa
  if norm(ra - rb) > d
    Fa = [0, 0, 0];
  else
    Fa = k * (ra - rb) / norm(ra - rb)^2;
  end
  Fb = -Fa; % principle of symmetry of flux

  %% step forward in time with balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;
  Pb = Pb + (Fb + Gb) * dt;
  rb = rb + vb * dt; %@

  %% plot
  if t > tplot
    subplot(2, 1, 1); plot(t, ra(3), '.b')
    subplot(2, 1, 2); plot(t, rb(3), '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
