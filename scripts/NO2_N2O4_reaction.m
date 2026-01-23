%%% Simulation of dimerization-dissociation reaction
%% Coordinates (t)

%% Constants
R = 8.31446261815324;  % J/(K*mol): molar gas constant
A1 = 1.88e5;         % m^3/(mol*s): 7re-exp. NO2
E1 = -2.23e3;        % J/mol: activation en. NO2
A2 = 4.30e15;       % 1/s: pre-exp N2O4
E2 = 5.32e4;        % J/mol: activation en. N2O4

%% Initial conditions. State: (N_NO2, N_N2O4, z, v, T)
t = 0;            % s: time
N_NO2 = 0.00;      % mol: amount NO2
N_N2O4 = 0.03;     % mol: amount N2O4

%% Boundary conditions
T = 330; %273.15 + 47;  % K: temperature
V = 0.001;            % m^3: volume

%% Time-iteration parameters
t1 = 0.0000001;        % s: final time
dtmin = 2e-10;  % s: time step %@

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(t, N_NO2, '.r'); hold on ; plot(t, N_N2O4, '.g')
xlim([0, t1])
xlabel('{\it t}/s'); ylabel('{\it N}/mol')
axis('tight'); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  xino2 = V * A1 * exp(-E1 / (R * T)) * (N_NO2 / V)^2;
  xin2o4 = V * A2 * exp(-E2 / (R * T)) * (N_N2O4 / V);
  Rno2 = -2 * xino2 + 2 * xin2o4;
  Rn2o4 = Rno2/(-2);

  %% step forward in time with balance laws
  %% adaptive timestep, temporary
  dt = 0.001 * min(abs([0.0001, N_NO2/Rno2, N_N2O4/Rn2o4 ...
                                %, z/v, E/Phi, Ppis/(Fpis+Gpis)
  ]));
  if dt < dtmin ; dt = dtmin ; end

  t = t + dt;
  N_NO2 = N_NO2 + Rno2 * dt;
  N_N2O4 = N_N2O4 + Rn2o4 * dt; %@

  %% plot
  if t > tplot
    plot(t, N_NO2, '.r'); plot(t, N_N2O4, '.g')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
