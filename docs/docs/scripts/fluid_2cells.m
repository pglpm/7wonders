%%%% Numerical time integration of piston-gas-spring
%% SI units used throughout
%% Vertical coordinate z, positive upward #\iffalse
clearvars; %\fi@

rho = 0.028; % molar mass
A = 0.01^2; % cell area/m^2
V = 0.01^3; % cell volume/m^2
T = 300; % temperature
R = 8.31446; % molar gas constant

t = 0; % initial time
dt = 0.0000001; % time step
t_end = dt*1500; % final time

N1 = 1; % initial amount/mol in cell 1
N2 = 0.5; % initial amount/mol in cell 2
P1 = 0; % initial x-momentum in cell 1
P2 = 0; % initial x-momentum in cell 2
J1in = 0; % matter flux into cell 1
J2out = 0; % matter flux out of cell 2
F1in = 0; % momentum flux into cell 1
F2out = 0; % momentum flux out of cell 2

%\iffalse
%% Plot & saving
%% adjust final time if not multiple of timestep
t_end = t_end + mod(t_end-t,dt);
%% Save values of all quantities at some steps during the simulation,
%% for subsequente analysis or plotting
%% (saving at all timesteps could be too costly)
Nsaves = 200; % number of timepoints to save during the simulation
%% Calculate time interval for saving
dsave = (t_end-t)/(Nsaves-1);
if abs(dsave) < (dt)
  error('time interval between saves is smaller than timestep')
end
%% Initialize vectors to contain saved values
tSave = nan(Nsaves,1);
N1Save = nan(Nsaves,1);
N2Save = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
N1Save(1) = N1;
N2Save(1) = N2;
J12 = 0;
F12 = 0;
%% Numerical time integration
%\fi@
while t < t_end
  pressure12 = R * T * (N1+N2)/(V+V);
  F12 = J12 * (P1+P2)/(N1+N2) + A * pressure12;
  J12 = A/rho * (P1+P2)/(V+V);

  pressure1 = R * T * N1/V;
  pressure2 = - R * T * N2/V;

  N1 = max(N1 + (J1in - J12)*dt, 0);
  N2 = max(N2 + (J12 - J2out)*dt, 0);
  P1 = P1 + (F1in - F12 + A*pressure1) * dt;
  P2 = P2 + (F12 - F2out + A*pressure2) * dt;

  t = t + dt; %\iffalse
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= dt/2
    i = i+1;
    tSave(i) = t;
    N1Save(i) = N1;
    N2Save(i) = N2;
  end %\fi@
end %\iffalse
%% Plot trajectory
%close all;
subplot(2,1,1)
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave, N1Save,'-','Color',cols(1,:));
xlabel('time {\it t}/s'); ylabel('amount {\it N1}/mol');
axis('tight'); 
ylim([0 max(N1Save)]);
grid minor;

subplot(2,1,2)
plot(tSave, N2Save,'-','Color',cols(1,:));
xlabel('time {\it t}/s'); ylabel('amount {\it N2}/mol');
axis('tight'); 
ylim([0 max(N2Save)]);
grid minor;
