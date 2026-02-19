%%% Numerical simulation of object motion with gravity
%% Coordinates (t, x, z)

%% Constants
ma = 2e30;  % kg: mass-energy tennis ball a
mb = 6e24;  % kg: mass-energy tennis ball b
kappa = 6.67408e-38;    % N/kg: gravitational acceleration

%% Initial conditions
t = 0;         % s: initial time
ra = [-0.35, 0.10];   % m: initial position tennis ball a
va = [-6.2e-12, 9.3e-9];   % m/s: initial velocity ball a
Pa = ma * va;  % N s: initial momentum ball a
rb = [150, 0];   % m: initial position ball b
vb = [0, -3e-5];  % m/s: initial velocity ball b
Pb = mb * vb;  % N s: initial momentum ball b

%% Boundary conditions
Fa = [0, 0];  % N: momentum supply ball a
Fb = [0, 0];  % N: momentum supply ball b

%% Time-iteration parameters
t1 = 63115200;       % s: final time
dt = 3600;  % s: time step

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(ra(1), ra(2), 'o', 'color', '#4477AA')
hold on; plot(rb(1), rb(2), 's', 'color', '#EE6677')
xlabel('{\it x}/m'); ylabel('{\it z}/m')
axis('tight'); axis('equal'); grid on; hold on

%% Numerical time integration
while t < t1

  %% constitutive relations
  va = Pa / ma;
  vb = Pb / mb;
  Ga = - kappa * ma * mb * (ra - rb) / norm(ra - rb)^3;
  Gb = -Ga;

  %% step forward in time with balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;
  Pb = Pb + (Fb + Gb) * dt;
  rb = rb + vb * dt;

  %% plot
  if t > tplot
    plot(ra(1), ra(2), 'o', 'color', '#4477AA')
    hold on; plot(rb(1), rb(2), 's', 'color', '#EE6677')
    xlabel('{\it x}/m'); ylabel('{\it z}/m')
    axis('tight'); axis('equal'); grid on; hold on
    pause(0)
    tplot = tplot + dtplot;
  end
end
