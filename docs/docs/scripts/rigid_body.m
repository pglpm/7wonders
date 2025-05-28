%%% Simulation of rigid body (ball)
%% Coordinates (t, x, y, z)

%% Constants
m = 5;     % kg: mass of object
R = 0.1;   % m: radius
g = 9.81;  % N/kg: gravitational acceleration
k = 1e5;   % N/m: elastic coefficient


%% Initial conditions
t = 0;                  % s: initial time
rc = [R, 0, 0];         % m: centre of mass-energy
vc = [0, 0, 0];         % m/s: velocity of mass-energy centre
omega = [20*pi, 0, 0];  % rad/s angular velocity of object
rp = [0, 0, 0];         % m: pivot point
r1 = [2 * R, 0, 0];     % m: point at extremity
r2 = [R, 0, R];         % m: point on border
Ic = (2 / 5) * m * R^2 * [1, 0, 0; 0, 1, 0; 0, 0, 1]; % inertia tens.

%% Boundary conditions
G = -m * g * [0, 0, 1];  % N: gravity supply on object
M = 0;                   % Nm: surface torque

%% Parameters for time loop
t1 = 5;         % s: final time
dt = 0.000001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
figure
plot3(rp(1), rp(2), rp(3), 'sy')
xlim([-0.3, 0.3]); ylim([-0.3, 0.3]); zlim([-0.3, 0.3])
axis square
hold on; grid on
%%
plot3([rp(1), r1(1)], [rp(2), r1(2)], [rp(3), r1(3)], '-b')
plot3([rp(1), r2(1)], [rp(2), r2(2)], [rp(3), r2(3)], '-r')
plot3([r1(1), r2(1)], [r1(2), r2(2)], [r1(3), r2(3)], '-r')
%% plot3(r(1), r(2), r(3), 'or')
hold off
%%
%% plot3(r(1), r(2), r(3), '.r')
xlabel('{\it x}/m'); ylabel('{\it y}/m'); zlabel('{\it z}/m') %@

%% State: rc, vc, Ic, omega, r
%% Numerical time integration
while t < t1
  %% constitutive relations
  P = m * vc;
  F = -k * rp;
  L = cross(rc, P) + omega * Ic';
  Tau = cross(rc, G);
  Om = [0, -omega(3), omega(2); omega(3), 0, -omega(1); -omega(2), omega(1), 0];
  vp = vc + cross(omega, rp - rc);
  v1 = vc + cross(omega, r1 - rc);
  v2 = vc + cross(omega, r2 - rc);

  %% balances
  t = t + dt;
  rc = rc + vc * dt;
  Ic = Ic + (Om * Ic - Ic * Om) * dt;
  P = P + (F + G) * dt;
  L = L + (M + Tau) * dt;
  rp = rp + vp * dt;
  r1 = r1 + v1 * dt;
  r2 = r2 + v2 * dt;

  %% constitutive relations
  vc = P / m;
  omega = (L - cross(rc, P)) * inv(Ic)'; %@

  %% plot
  if t > tplot
    plot3(rp(1), rp(2), rp(3), 'sy')
    hold on
    plot3([rp(1), r1(1)], [rp(2), r1(2)], [rp(3), r1(3)], '-b')
    plot3([rp(1), r2(1)], [rp(2), r2(2)], [rp(3), r2(3)], '-r')
    plot3([r1(1), r2(1)], [r1(2), r2(2)], [r1(3), r2(3)], '-r')
    xlim([-0.3, 0.3]); ylim([-0.3, 0.3]); zlim([-0.3, 0.3])
    axis square
    %% plot3(r(1), r(2), r(3), 'or')
    hold off
    %%
    %% plot3(r(1), r(2), r(3), '.r')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
