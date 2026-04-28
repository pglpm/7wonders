%%% Simulation of falling chain of springs
%% Coordinates (t, z)

%% Constants
m = 0.1;  % kg: mass between springs
g = 9.8;  % N/kg: gravitational acceleration
L = 0.1;  % m: natural length
K = 50;   % N/m: elastic constant

%% Constitutive relation for force of rubber band
function F = force(z1, z2, L, K)
  if abs(z1 - z2) > L
    F = -K * (z1 - z2 - L);
  else
    F = 0;
  end
end

%% Initial conditions
t = 0;             % s: initial time
zc4 = -0.0000;     % m: position mass 4 (top)
zc3 = -0.1588;     % m: position mass 3
zc2 = -0.2980;     % m: position mass 2
zc1 = -0.4176;     % m: position mass 1 (bottom)
vc4 = 0;           % m/s: velocity mass 4
vc3 = 0;           % m/s: velocity mass 3
vc2 = 0;           % m/s: velocity mass 2
vc1 = 0;           % m/s: velocity mass 1
Ftop = 4 * m * g;  % N: initial force top

%% Boundary conditions
Fbot = 0;     % N: constant force bottom
G = - m * g;  % N: gravity supply to one mass

%% Parameters for time loop
trelease = 0.1; %s: release time
t1 = 0.2;      % s: final time
dt = 0.0001;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
figure
plot(t, zc4, 'o', 'color', '#228833')
plot(t, zc3, 's', 'color', '#EE6677')
plot(t, zc2, 'o', 'color', '#4477AA')
plot(t, zc1, 's', 'color', '#000000')
axis('tight'); xlim([0, t1]); grid on; hold on
xlabel('{\it t}/s'); ylabel('{\it z}/m') %@

%% State: zc1, zc2, zc3, zc4, vc1, vc2, vc3, vc4
%% Numerical time integration
while t < t1
  %% no more top force at trelease
  if t < trelease
    Ftop = 4 * m * g;
  else
    Ftop = 0;
  end

  %% constitutive relations
  F34 = force(zc4, zc3, L, K);
  F23 = force(zc3, zc2, L, K);
  F12 = force(zc2, zc1, L, K);
  F4 = F34 + Ftop;
  F3 = F23 - F34;
  F2 = F12 - F23;
  F1 = -F12 + Fbot;
  P1 = m * vc1;
  P2 = m * vc2;
  P3 = m * vc3;
  P4 = m * vc4;

  %% balances
  t = t + dt;
  P1 = P1 + (F1 + G) * dt;
  P2 = P2 + (F2 + G) * dt;
  P3 = P3 + (F3 + G) * dt;
  P4 = P4 + (F4 + G) * dt;
  zc1 = zc1 + vc1 * dt;
  zc2 = zc2 + vc2 * dt;
  zc3 = zc3 + vc3 * dt;
  zc4 = zc4 + vc4 * dt;

  %% constitutive relations
  vc1 = P1 / m;
  vc2 = P2 / m;
  vc3 = P3 / m;
  vc4 = P4 / m; %@

  %% plot
  if t > tplot
    plot(t, zc4, 'o', 'color', '#228833')
    plot(t, zc3, 's', 'color', '#EE6677')
    plot(t, zc2, 'o', 'color', '#4477AA')
    plot(t, zc1, 's', 'color', '#000000')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
