%%% Simulation of reaction in cylinder & piston, 1D
%% Coordinates (t, z)

%% Constants
R = 8.31446261815324;  % J/(K*mol): molar gas constant
g = 9.80665;           % N/kg: gravitational acceleration
Cno2 = 29;             % J/(K*mol): molar heat capacity NO2
Cn2o4 = 72;            % J/(K*mol): molar heat capacity N2O4
mu = 4e-5;             % N*s/m^2: gas viscosity
h = 0 * 10e3;          % J/(K*m^2): heat-transfer coefficient
A = 0.03^2;            % m^2: area of piston
m = 1;                 % kg: mass of piston
Ano2 = 1.88e5;         % m^3/(mol*s): pre-exp. NO2
Eno2 = -2.23e3;        % J/mol: activation en. NO2
An2o4 = 4.30e15;       % 1/s: pre-exp N2O4
En2o4 = 5.32e4;        % J/mol: activation en. N2O4

%% Initial conditions. State: (Nno2, Nn2o4, z, v, T)
t = 0;            % s: time
Nno2 = 0.00;      % mol: amount NO2
Nn2o4 = 0.03;     % mol: amount N2O4
z = 1;            % m: position of piston
v = 0;            % m/s: velocity of piston
T = 273.15 + 47;  % K: temperature of gas

%% Boundary conditions
Gpis = -m * g;       % N: gravity supply of momentum to piston
Fatm = -101325 * A;  % N: force on piston by atmosphere
Tbot = 273.15 + 47;  % K: temperature of environment

%% Time-iteration parameters
t1 = 1;        % s: final time
dtmin = 2e-9;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
figure
subplot(3, 1, 1); plot(t, z, '.b')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it z}/m')
axis('tight'); grid on; hold on
subplot(3, 1, 2); plot(t, T, '.k')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it T}/K')
axis('tight'); grid on; hold on
subplot(3, 1, 3); plot(t, Nno2, '.r');
hold on ; plot(t, Nn2o4, '.g')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it N}/mol')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  V = A * z;
  xino2 = V * Ano2 * exp(-Eno2 / (R * T)) * (Nno2 / V)^2;
  xin2o4 = V * An2o4 * exp(-En2o4 / (R * T)) * (Nn2o4 / V);
  Rno2 = -2 * xino2 + 2 * xin2o4;
  Rn2o4 = Rno2/(-2);
  Fgas = -(R * (Nno2 + Nn2o4) * T / z -  mu * A * v / z);
  Fpis = -Fgas + Fatm;
  Ppis = m * v;
  Phibot = A * h * (Tbot - T);
  Phitop = Fgas * v;
  Phi = Phibot + Phitop;
  E = (Cno2 * Nno2 + Cn2o4 * Nn2o4) * T;

  %% step forward in time with balance laws
  %% adaptive timestep, temporary
  dt = 0.01 * min(abs([0.1, Nno2/Rno2, Nn2o4/Rn2o4 ...
                                %, z/v, E/Phi, Ppis/(Fpis+Gpis)
  ]));
  if dt < dtmin ; dt = dtmin ; end

  t = t + dt;
  Nno2 = Nno2 + Rno2 * dt;
  Nn2o4 = Nn2o4 + Rn2o4 * dt;
  Ppis = Ppis + (Fpis + Gpis) * dt;
  z = z + v * dt;
  E = E + Phi * dt;

  %% constitutive relations: calculate state
  T = E / (Cno2 * Nno2 + Cn2o4 * Nn2o4);
  v = Ppis / m; %@

  %% plot
  if t > tplot
    subplot(3, 1, 1); plot(t, z, '.b')
    subplot(3, 1, 2); plot(t, T, '.k')
    subplot(3, 1, 3); plot(t, Nno2, '.r'); plot(t, Nn2o4, '.g')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
