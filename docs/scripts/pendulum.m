%%% Simulation of pendulum in 2D
%% Coordinates (t, x, z)

%% Constants
m = 2;    % kg: mass of object
g = 9.8;  % N/kg: gravitational acceleration
k = 50;   % N/m: spring constant

%% Initial conditions
t = 0;            % s: initial time
r = [0, -0.5];  % m: initial position of object
v = [1, 0];       % m/s: initial velocity of object

%% Boundary conditions
G = -m * g * [0, 1]; % N: gravity supply on object

%% Parameters for time loop
t1 = 20;        % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(0, 0, 'x', 'color', '#000000')
xlim([-1, 1]); ylim([-1, 1])
hold on; grid on; axis equal
plot([0, r(1)], [0, r(2)], '-', 'color', '#4477AA')
plot(r(1), r(2), 'o', 'color', '#EE6677')
xlabel('{\it x}/m'); ylabel('{\it z}/m') %@

%% State: r, v
%% Numerical time integration
while t < t1

  %% constitutive relations
  P = m * v;
  F = -k * r;

  %% balances
  t = t + dt;
  P = P + (F + G) * dt;
  r = r + v * dt;

  %% constitutive relations
  v = P / m; %@

  %% plot
  if t > tplot
    hold off
    plot(0, 0, 'x', 'color', '#000000')
    xlim([-1, 1]); ylim([-1, 1])
    hold on; grid on; axis equal
    plot([0, r(1)], [0, r(2)], '-', 'color', '#4477AA')
    plot(r(1), r(2), 'o', 'color', '#EE6677')
    xlabel('{\it x}/m'); ylabel('{\it z}/m')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
