%%% Time integration of dimerization-dissociation reaction
%% Coordinates (t)

%% Constants
V = 0.001;   % m^3: volume
C1 = 4.2e5;  % m^3/(mol*s): factor  2NO2 -> N2O4
C2 = 1.6e7;  % 1/s: factor  N2O4 -> 2NO2

%% Initial conditions
t = 0;          % s: time
N_NO2 = 0.00;   % mol: amount NO2
N_N2O4 = 0.04;  % mol: amount N2O4

%% Boundary conditions
J_NO2 = 0;   % mol/s: influx of NO2
J_N2O4 = 0;  % mol/s: influx of N2O4

%% Time-iteration parameters
%% uncomment these for longer time integration
t1 = 0.01;  % s: final time
dt = 1e-8;  % s: time step
%% uncomment these for shorter time integration
% t1 = 2e-7;   % s: final time
% dt = 1e-10;  % s: time step %@

%% Plotting
dtplot = t1/60;  % time interval between plots
tplot = dtplot;   % time for next plot
figure; plot(t, N_NO2, 'v', 'color', '#EE6677')
hold on; plot(t, N_N2O4, 'x', 'color', '#CCBB44')
legend('NO_2', 'N_2O_4')
legend('fontsize', 24, 'box', 'off', 'autoupdate', 'off')
xlim([0, t1]); xlabel('{\it t}/s'); ylabel('{\it N}/mol')
axis('tight'); grid on %@

%% Numerical time integration
while t < t1
  %% constitutive relations: rates of conversion
  xidot1 = C1 * (N_NO2)^2 / V;
  xidot2 = C2 * N_N2O4;
  %% constitutive relations: rates of formation (supplies)
  R_NO2 = -2 * xidot1 + 2 * xidot2;
  R_N2O4 = xidot1 - xidot2;

  %% step forward in time with balance laws
  t = t + dt;
  N_NO2 = N_NO2 + (J_NO2 + R_NO2) * dt;
  N_N2O4 = N_N2O4 + (J_N2O4 + R_N2O4) * dt; %@

  %% plot
  if t > tplot
    plot(t, N_NO2, 'v', 'color', '#EE6677')
    plot(t, N_N2O4, 'x', 'color', '#CCBB44')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
