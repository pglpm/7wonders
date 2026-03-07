%%% Simulation of billiard balls, no slip
%% Coordinates (t, x, y)

%% Constants
m = 0.16; % kg: mass of each ball
R = 0.057/2; % m: radius of each ball
Ic = 2 * m * R^2 / 5; % kg m^2: inertia tensor of each ball
Dmin = 2 * R; # m: minimum distance for impact force
k = 1000; # N/m: elastic constant impact force
scoeff = -Ic / (m * R^2 + Ic); # rolling-friction coeff.

%% Initial conditions, state: (r1, v1, o1, r2, v2, o2)
t = 0;
r1 = [0, 0];
v1 = [0, 1];
o1 = [-v1(2), v1(1), 0] / R;
r2 = [-2*R * 3/4, 0.2];
v2 = [0, 0];
o2 = [-v2(2), v2(1), 0] / R;

%% Boundary conditions


%% Parameters for time loop
t1 = 3; % s: final time
dt = 0.001; % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(r1(1), r1(2), 'o', 'color', '#4477AA', 'markersize', 8); hold on
plot(r2(1), r2(2), 'o', 'color', '#EE6677', 'markersize', 8)
xlabel('{\it x}/m'); ylabel('{\it z}/m')
xlim([-1, 1]); ylim([-1, 1])
axis('equal'); grid on; pause(0) %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  %% calculations for impact force, rolling friction, torque
  D = norm(r1 - r2);
  if D > Dmin
    F1i = [0, 0];
    F1r = scoeff * F1i;
    M1i = [0, 0, 0];
    M1r = [0, 0, 0];
  else
    F1i = - k * (D - Dmin) * (r1 - r2) / D;
    F1r = scoeff * F1i;
    M1i = cross([(r1 + r2) / 2, 0], [F1i, 0]);
    M1r = cross([r1, -R], [F1r, 0]);
  end
  F2i = -F1i;
  F2r = -F1r;
  M2i = -M1i;
  M2r = -M1r;
  %%
  F1 = F1i + F1r;
  F2 = F2i + F2r;
  M1 = M1i + M1r;
  M2 = M2i + M2r;
  %%
  P1 = m * v1;
  P2 = m * v2;
  %%
  L1 = cross([r1, 0], [P1, 0]) + Ic * o1;
  L2 = cross([r2, 0], [P2, 0]) + Ic * o2;

  %% balance laws
  t = t + dt;
  P1 = P1 + F1 * dt;
  P2 = P2 + F2 * dt;
  L1 = L1 + M1 * dt;
  L2 = L2 + M2 * dt;
  r1 = r1 + v1 * dt;
  r2 = r2 + v2 * dt;

  %% constitutive relations: find new state variables
  v1 = P1 / m;
  v2 = P2 / m;
  o1 = (L1 - cross([r1, 0], [P1, 0])) / Ic;
  o2 = (L2 - cross([r2, 0], [P2, 0])) / Ic;  %@

  %% plot
  if t > tplot
    hold off;
    plot(r1(1), r1(2), 'o', 'color', '#4477AA', 'markersize', 8); hold on
    plot(r2(1), r2(2), 'o', 'color', '#EE6677', 'markersize', 8)
    xlim([-1, 1]); ylim([-1, 1]); axis('equal');
    pause(0)
    tplot = tplot + dtplot;
  end %@
end

