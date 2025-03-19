%%% Simulation of rigid body (ball)
%% Coordinates (t, x, y, z)

%% Constants
m = 5;     % kg: mass of object
R = 0.1; % m: radius
g = 9.81;  % N/kg: gravitational acceleration
k = 1e5;


%% Initial conditions
t = 0;                               % s: initial time
rc = [R, 0, 0]; % m: centre of mass-energy
vc = [0, 0, 0]; % m/s: velocity of mass-energy centre
omega = [20*pi, 0, 0]; % rad/s angular velocity of object
Ic = (2 / 5) * m * R^2 * [1, 0, 0; 0, 1, 0; 0, 0, 1]; % inertia tens.
r = [2* R, 0, 0]; % m: a point
rp = [0, 0, 0];

%% Boundary conditions
G = -m * g * [0, 0, 1]; % N: gravity supply on object
M = 0; % Nm: surface torque

%% Parameters for time loop
t1 = 5;      % s: final time
dt = 0.000001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
figure
plot(r(1), r(3), '.b')
xlim([-0.3, 0.3]); ylim([-0.3, 0.3])
hold on; grid on; axis equal
xlabel('{\it x}/m'); ylabel('{\it z}/m') %@

%% State: rc, vc, Ic, omega, r
%% Numerical time integration
while t < t1
  %% constitutive relations
  P = m * vc;
  F = -k * rp;
  L = cross(rc, P) + omega * Ic';
  Tau = cross(rc, G);
  Om = [0, -omega(3), omega(2); omega(3), 0, -omega(1); -omega(2), omega(1), 0];
  v = vc + cross(omega, r - rc);
  vp = vc + cross(omega, rp - rc);

  %% balances
  t = t + dt;
  rc = rc + vc * dt;
  Ic = Ic + (Om * Ic - Ic * Om) * dt;
  P = P + (F + G) * dt;
  L = L + (M + Tau) * dt;
  r = r + v * dt;
  rp = rp + vp * dt;

  %% constitutive relations
  vc = P / m;
  omega = (L - cross(rc, P)) * inv(Ic)'; %@

  %% plot
  if t > tplot
    plot(r(1), r(3), '.b')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
