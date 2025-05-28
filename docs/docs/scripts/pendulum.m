%%% Simulation of pendulum in 2D
%% Coordinates (t, y, z)

%% Constants
m = 2;     % kg: mass of object
g = 9.81;  % N/kg: gravitational acceleration
ln = 1;    % m: natural length
k = 5000;  % N/m: spring constant

%% Initial conditions
t = 0;                               % s: initial time
angle = pi/3;                        % rad: angle from vertical
r = ln * [sin(angle), -cos(angle)];  % m: initial position of object
v = [0, 0];                          % m/s: initial velocity of object

%% Boundary conditions
G = -m * g * [0, 1]; % N: gravity supply on object

%% Parameters for time loop
t1 = 10;      % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
figure
plot(0, 0, 'sk')
xlim([-ln, ln]); ylim([-ln, 0])
hold on; grid on; axis equal
plot([0, r(1)], [0, r(2)], '-b')
plot(r(1), r(2), 'ob')
xlabel('{\it y}/m'); ylabel('{\it z}/m') %@

%% State: ra, rb, va, vb
%% Numerical time integration
while t < t1
  %% constitutive relations
  P = m * v;
  l = norm(r); % calculation of present length
  F = -k * (l - ln) * r / l;

  %% balances
  t = t + dt;
  P = P + (F + G) * dt;
  r = r + v * dt;

  %% constitutive relations
  v = P / m; %@

  %% plot
  if t > tplot
    hold off
    plot(0, 0, 'sk')
    xlim([-ln, ln]); ylim([-ln, 0])
    hold on; grid on; axis equal
    plot([0, r(1)], [0, r(2)], '-b')
    plot(r(1), r(2), 'ob')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
