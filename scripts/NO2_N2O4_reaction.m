%%% Simulation of dimerization-dissociation reaction
%% Coordinates (t)

%% Constants
R = 8.31446261815324;  % J/(K*mol): molar gas constant
A1 = 1.88e5;         % m^3/(mol*s): pre-exp. NO2
E1 = -2.23e3;        % J/mol: activation en. NO2
A2 = 4.30e15;       % 1/s: pre-exp N2O4
E2 = 5.32e4;        % J/mol: activation en. N2O4

%% Initial conditions. State: (N_NO2, N_N2O4, z, v, T)
t = 0;            % s: time
N_NO2 = 0.00;      % mol: amount NO2
N_N2O4 = 0.04;     % mol: amount N2O4

%% Boundary conditions
T = 340;  % K: temperature
V = 0.001;            % m^3: volume

%% Time-iteration parameters
t1 = 5e-7;        % s: final time
dtmin = 1e-10;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(t, N_NO2, 'o', 'color', '#EE6677')
hold on ;
plot(t, N_N2O4, 'o', 'color', '#CCBB44')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it N}/mol')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  xi1 = A1 * exp(-E1 / (R * T)) * N_NO2^2 / V;
  xi2 = A2 * exp(-E2 / (R * T)) * N_N2O4;
  R_NO2 = -2 * xi1 + 2 * xi2;
  R_N2O4 = R_NO2/(-2);

  %% step forward in time with balance laws
  %% adaptive timestep, temporary
  t = t + dt;
  N_NO2 = N_NO2 + R_NO2 * dt;
  N_N2O4 = N_N2O4 + R_N2O4 * dt; %@

  %% plot
  if t > tplot
    plot(t, N_NO2, 'o', 'color', '#EE6677')
    plot(t, N_N2O4, 'o', 'color', '#CCBB44')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
