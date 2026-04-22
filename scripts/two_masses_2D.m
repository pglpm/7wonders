%%% Simulation of ideal gases, pistons, spring
%% Coordinates (t, x, z)

%% Constants
g = 9.8;         % N/kg: acceleration of free fall
R = 8.314462;    % N m/(K mol): molar gas constant
m = 20;          % kg: mass of each piston
Ln = 0.05;       % m: natural length spring
k = 1000;        % N/m: elastic constant spring
N = 0.01;        % mol: amount ideal gases
C = 20;          % J/(K mol): molar heat capacity
h = 1000;        % J/(s K m^2): heat-transfer coeff.
area = 0.02^2;   % m^2: base area of gas cylinder
r1 = [-0.2, 0];  % m: position fixed-end cylinder 1
r2 = [0.2, 0];   % m: position fixed-end cylinder 2
Tout = 298.15;   % K: external temperature

%% Initial conditions, state: (rA, vA, rB, vB, T)
t = 0;           % s: time
rA = [0, 0.1];   % m: position piston A
vA = [0, 0];     % m/s: velocity piston A
rB = [0, -0.1];  % m: position piston B
vB = [0, 0];     % m/s: velocity piston B
T1 = 298.15;      % K: temperature gas 1
T2 = 298.15;      % K: temperature gas 2

%% Boundary conditions
GA = [0, 0];  % N: momentum supply piston A
GB = [0, 0];  % N: momentum supply piston B

%% Parameters for time integration
t1 = 5;        % s: final time
dt = 0.00001;  % s: time step
%@
%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
subplot(2, 1, 1);
plot(rA(1), rA(2), 'o', 'color', '#AA3377'); hold on
plot(rB(1), rB(2), 's', 'color', '#EE6677');
plot([r1(1), rA(1)], [r1(2), rA(2)], '-', 'color', '#4477AA')
plot([r2(1), rB(1)], [r2(2), rB(2)], '-', 'color', '#4477AA')
plot([rA(1), rB(1)], [rA(2), rB(2)], '--', 'color', '#66CCEE')
xlim([-0.5, 0.5]); ylim([-0.5, 0.5]); axis('equal')
xlabel('{\it x}/m'); ylabel('{\it y}/m'); grid on
subplot(2, 1, 2); plot(t, T1, '*', 'color', '#000000')
xlabel('{\it t}/s'); ylabel('{\it T_1}/K')
axis('tight'); xlim([0, t1]); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% useful quantities to calculate beforehand
  L1 = norm(rA - r1);  % length cylinder 1
  L2 = norm(rB - r2);  % length cylinder 2
  Ls = norm(rA - rB);  % length spring
  V1 = area * L1;       % volume gas 1
  V2 = area * L2;       % volume gas 2

  PA = m * vA;
  F1A = area * (R * N * T1 / V1) * (rA - r1) / L1;
  FsA = -k * (Ls - Ln) * (rA - rB) / Ls;
  FA = F1A + FsA;
  
  PB = m * vB;
  F2B = area * (R * N * T2 / V2) * (rB - r2) / L2;
  FsB = -k * (Ls - Ln) * (rB - rA) / Ls;
  FB = F2B + FsB;
  
  E1 = C * N * T1;
  Q1end = area * h * (Tout - T1);
  Phi1end = Q1end;
  Q1A = area * h * (Tout - T1);
  Phi1A = Q1A + dot(-F1A, vA);
  Phi1 = Phi1end + Phi1A;
  
  E2 = C * N * T2;
  Q2end = area * h * (Tout - T2);
  Phi2end = Q2end;
  Q2B = area * h * (Tout - T2);
  Phi2B = Q2B + dot(-F2B, vB);
  Phi2 = Phi2end + Phi2B;

  t = t + dt;
  PA = PA + (FA + GA) * dt;
  PB = PB + (FB + GB) * dt;
  E1 = E1 + Phi1 * dt;
  E2 = E2 + Phi2 * dt;
  rA = rA + vA * dt;
  rB = rB + vB * dt;

  vA = PA / m;
  vB = PB / m;
  T1 = E1 / (C * N);
  T2 = E2 / (C * N);
%@
  %% plot
  if t > tplot
    subplot(2, 1, 1); hold off
    plot(rA(1), rA(2), 'o', 'color', '#AA3377'); hold on
    plot(rB(1), rB(2), 's', 'color', '#EE6677');
    plot([r1(1), rA(1)], [r1(2), rA(2)], '-', 'color', '#4477AA')
    plot([r2(1), rB(1)], [r2(2), rB(2)], '-', 'color', '#4477AA')
    plot([rA(1), rB(1)], [rA(2), rB(2)], '--', 'color', '#66CCEE')
    xlim([-0.5, 0.5]); ylim([-0.5, 0.5]); axis('equal')
    subplot(2, 1, 2); plot(t, T1, '*', 'color', '#000000')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
