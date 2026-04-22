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
Q1A = 0; % J/s: energy flux to gas 1 at piston
Q2 = 0; % J/s: energy flux to gas 2 at piston

%% Parameters for time integration
t1 = 5;        % s: final time
dt = 0.00001;  % s: time step

%% Numerical time integration
while t < t1
  %% useful quantities to calculate beforehand
  L1 = norm(rA - r1);  % length cylinder 1
  L2 = norm(rB - r2);  % length cylinder 2
  Ls = norm(rA - rB);  % length spring
  V1 = area * L1;       % volume gas 1
  V2 = area * L2;       % volume gas 2

  PA = m * vA;
  FA_gas1 = area * (R * N * T1 / V1) * (rA - r1) / L1;
  FA_spring = -k * (Ls - Ln) * (rA - rB) / Ls;
  FA = FA_gas1 + FA_spring;
  
  PB = m * vB;
  FB_gas2 = area * (R * N * T2 / V2) * (rB - r2) / L2;
  FB_spring = -k * (Ls - Ln) * (rB - rA) / Ls;
  FB = FB_gas2 + FB_spring;
  
  E1 = C * N * T1;
  Q1_end = area * h * (Tout - T1);
  Phi1_end = Q1_end;
  Phi1_A = Q1_A + dot(-FA_gas1, vA);
  Phi1 = Phi1_end + Phi1_A;
  
  E2 = C * N * T2;
  Phi2 = Q2 + dot(-F2B, vB);

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
end
