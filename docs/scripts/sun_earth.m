%%% Numerical simulation of Sun and Earth
%% Coordinates (t, x, y)
%% length unit is 10^9 m

%% Constants
ma = 2e30;            % kg: mass-energy Sun
mb = 6e24;            % kg: mass-energy Earth
kappa = 6.67408e-38;  % 10^27 N m^2/kg^2: gravitational constant

%% Initial conditions
t = 0;                    % s: initial time
ra = [-0.35, 0.10];       % 10^9 m: initial position Sun
va = [-6.2e-12, 9.3e-9];  % 10^9 m/s: initial velocity Sun
Pa = ma * va;             % 10^9 N s: initial momentum Sun
rb = [150, 0];            % 10^9 m: initial position Earth
vb = [0, -3e-5];          % 10^9 m/s: initial velocity Earth
Pb = mb * vb;             % 10^9 N s: initial momentum Earth

%% Boundary conditions
Fa = [0, 0];  % N: surface force Sun
Fb = [0, 0];  % N: surface force Earth

%% Time-iteration parameters
t1 = 63115200;  % s: final time (2 years)
dt = 3600;      % s: time step (1 h)

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(ra(1), ra(2), '*', 'color', '#CCBB44')
hold on; plot(rb(1), rb(2), 'o', 'color', '#4477AA')
xlabel('{\it x}/m'); ylabel('{\it z}/m')
axis('tight'); axis('equal'); grid on; hold on

%% Numerical time integration
while t < t1

  %% constitutive relations
  va = Pa / ma;
  vb = Pb / mb;
  Ga = - kappa * ma * mb * (ra - rb) / norm(ra - rb)^3;
  Gb = - kappa * mb * ma * (rb - ra) / norm(rb - ra)^3;

  %% step forward in time with balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;
  Pb = Pb + (Fb + Gb) * dt;
  rb = rb + vb * dt;

  %% plot
  if t > tplot
    plot(ra(1), ra(2), '*', 'color', '#CCBB44')
    hold on; plot(rb(1), rb(2), 'o', 'color', '#4477AA')
    xlabel('{\it x}/m'); ylabel('{\it z}/m')
    axis('tight'); axis('equal'); grid on; hold on
    pause(0)
    tplot = tplot + dtplot;
  end
end
