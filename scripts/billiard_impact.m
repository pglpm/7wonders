%%% Simulation of billiard balls, with impact friction
%% Coordinates (t, x, y)

%% Constants
m = 0.16; % kg: mass of each ball
R = 0.057/2; % m: radius of each ball
Ic = 2 * m * R^2 / 5; % kg m^2: inertia tensor of each ball
Dmin = 2 * R; % m: minimum distance for impact force
k = 1000; % N/m: elastic constant impact force
mu = 1000; % friction constant impact force
rcoeff = -Ic / (m * R^2 + Ic); % rolling-friction coeff.

%% Initial conditions, state: (r1, v1, o1, r2, v2, o2)
t = 0;
r1 = [0, 0];
v1 = [0, 1];
o1 = [-v1(2), v1(1), -10] / R;
r2 = [-2*R * 3/4, 0.2];
v2 = [0, 0];
o2 = [-v2(2), v2(1), 0] / R;

%% output initial momentum, ang. momentum, kin. energy
Ptot = m * (v1 + v2)
Ltot = cross([r1, 0], [m * v1, 0]) + Ic * o1 + ...
       cross([r2, 0], [m * v2, 0]) + Ic * o2
Ek = 0.5 * m * (norm(v1)^2 + norm(v2)^2) + ...
     0.5 * Ic * (norm(o1)^2 + norm(o2)^2)

%% Boundary conditions

%% Parameters for time loop
t1 = 0.3; % s: final time
dt = 0.0001; % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
subplot(2, 1, 1)
plot(r1(1), r1(2), 'o', 'color', '#4477AA', 'markersize', 4); hold on
plot(r2(1), r2(2), 'o', 'color', '#EE6677', 'markersize', 4)
xlabel('{\it x}/m'); ylabel('{\it y}/m')
xlim([-1, 1]); ylim([-1, 1])
axis('equal'); grid on;
subplot(2, 1, 2)
plot(t, Ek, 'ok'); hold on
xlabel('{\it t}/s'); ylabel('{\it E_k}/J')
xlim([0, t1]); axis('tight'); grid on;
pause(0) %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  %% calculations for impact force & torque, and
  %% rolling friction force & torque
  D = norm(r1 - r2);
  if D > Dmin % no contact
    F1in = [0, 0]; % normal impact force
    F1it = [0, 0]; % tangent impact force
    F1i = [0, 0]; % impact force
    F1r = rcoeff * F1i; % rolling friction
    M1i = [0, 0, 0]; % impact torque
    M1r = [0, 0, 0]; % rolling torque
  else % contact
    r12 = (r1 - r2) / D; % unit vector from ball 2 to ball 1
    F1in = - k * (D - Dmin) * r12;
    %% tangential velocities at contact
    vc1 = - cross(o1, [R * r12, 0]);
    vc1 = v1 - dot(v1, r12) * r12 + vc1(1:2);
    vc2 = + cross(o2, [R * r12, 0]);
    vc2 = v2 - dot(v2, r12) * r12 + vc2(1:2);
    vcn = norm(vc1 - vc2); % relative contact tang. velocity
    if vcn > 0 % calculate tangent impact force
      F1it = -mu * norm(F1in) * (vc1 - vc2) / vcn;
    else
      F1it = [0, 0];
    end
    F1i = F1in + F1it;
    F1r = rcoeff * F1i;
    M1i = cross([(r1 + r2) / 2, 0], [F1i, 0]);
    M1r = cross([r1, -R], [F1r, 0]);
  end
  F2i = -F1i;
  F2r = -F1r;
  M2i = -M1i;
  M2r = -M1r;
  %% extensivity
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
  o2 = (L2 - cross([r2, 0], [P2, 0])) / Ic;

  %% Extra: keep track of kinetic energy
  Ek = 0.5 * m * (norm(v1)^2 + norm(v2)^2) + ...
       0.5 * Ic * (norm(o1)^2 + norm(o2)^2); %@

  %% plot
  if t > tplot
    subplot(2, 1, 1); hold off
    plot(r1(1), r1(2), 'o', 'color', '#4477AA', 'markersize', 4); hold on
    plot(r2(1), r2(2), 'o', 'color', '#EE6677', 'markersize', 4)
    xlabel('{\it x}/m'); ylabel('{\it y}/m')
    xlim([-1, 1]); ylim([-1, 1])
    axis('equal'); grid on;
    subplot(2, 1, 2)
    plot(t, Ek, 'ok');
    pause(0)
    tplot = tplot + dtplot;
  end %@
end

Ptot = m * (v1 + v2)
Ltot = cross([r1, 0], [m * v1, 0]) + Ic * o1 + ...
       cross([r2, 0], [m * v2, 0]) + Ic * o2
Ek = 0.5 * m * (norm(v1)^2 + norm(v2)^2) + ...
     0.5 * Ic * (norm(o1)^2 + norm(o2)^2)
