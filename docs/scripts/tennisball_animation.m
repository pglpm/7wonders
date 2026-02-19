%%% Numerical simulation of object motion with gravity
%% Coordinates (t, x, z)

%% Constants
ma = 0.06;  % kg: mass-energy tennis ball a
g = 9.8;    % N/kg: gravitational acceleration

%% Initial conditions
t = 0;         % s: initial time
ra = [0, 5];   % m: initial position tennis ball a
va = [3, 7];   % m/s: initial velocity ball a
Pa = ma * va;  % N s: initial momentum ball a

%% Boundary conditions
Fa = [0, 0];            % N: momentum influx ball a
Ga = -ma * g * [0, 1];  % N: momentum supply ball a

%% Time-iteration parameters
t1 = 2;       % s: final time
dt = 0.0001;  % s: time step

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(ra(1), ra(2), 'o', 'color', '#4477AA')
xlabel('{\it x}/m'); ylabel('{\it z}/m')
axis('tight'); axis('equal'); grid on; hold on

%% Numerical time integration
while t < t1

  %% constitutive relations
  va = Pa / ma;

  %% step forward in time with balance laws
  t = t + dt;
  Pa = Pa + (Fa + Ga) * dt;
  ra = ra + va * dt;

  %% plot
  if t > tplot
    %% hold off
    plot(ra(1), ra(2), 'o', 'color', '#4477AA')
    xlabel('{\it x}/m'); ylabel('{\it z}/m')
    axis('tight'); axis('equal'); grid on; hold on
    pause(0)
    tplot = tplot + dtplot;
  end
end
