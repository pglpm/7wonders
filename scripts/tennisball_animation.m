%%% Numerical simulation of object motion with gravity
%% Coordinates (t, x, z)

%% Constants
m = 0.06;  % kg: tennis ball's mass-energy
g = 9.8;   % N/kg: gravitational acceleration

%% Initial conditions
t = 0;       % s: initial time
r = [0, 5];  % m: initial position
v = [3, 7];  % m/s: initial velocity
P = m * v;   % N s: initial momentum

%% Boundary conditions
F = [0, 0];           % N: momentum influx
G = -m * g * [0, 1];  % N: momentum supply

%% Time-iteration parameters
t1 = 2;       % s: final time
dt = 0.0001;  % s: time step

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(r(1), r(2), 'o', 'color', '#4477AA')
xlabel('{\it x}/m'); ylabel('{\it z}/m')
axis('tight'); axis('equal'); grid on; hold on

%% Numerical time integration
while t < t1

  %% constitutive relations
  v = P / m;

  %% step forward in time with balance laws
  t = t + dt;
  P = P + (F + G) * dt;
  r = r + v * dt;

  %% plot
  if t > tplot
    %% hold off
    plot(r(1), r(2), 'o', 'color', '#4477AA')
    xlabel('{\it x}/m'); ylabel('{\it z}/m')
    axis('tight'); axis('equal'); grid on; hold on
    pause(0)
    tplot = tplot + dtplot;
  end
end
