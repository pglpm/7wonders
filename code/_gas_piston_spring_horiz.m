%%%% Numerical time integration of piston-gas-spring
%% SI units used throughout
%% Vertical coordinate z, positive upward #\iffalse
clearvars; #\fi@

m = 50; % mass of piston
N = 0.04; % amount of ideal gas
A = 0.1^2; % area of piston
R = 8.31446261815; % molar gas constant
C = 20; % molar heat capacity of gas
mu = 0.00004; % gas viscosity
h = 8000; % heat-transfer coefficient
T_out = 300; % temperature of environment
k = 1000; % elastic constant of spring
lo = 0.8; % rest length of spring
zo = 1; % spring anchor

t_end = 11; % final time
dt = 0.0001; % time step

t = 0; % initial time
z = 0.15; % initial position of piston
v = 0; % initial velocity of piston
T = 300; % initial temperature of gas
#\iffalse
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
zSave = nan(Nsaves,1);
vSave = nan(Nsaves,1);
TSave = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
zSave(1) = z;
vSave(1) = v;
TSave(1) = T;
%% Numerical time integration
#\fi@
while t < t_end
  P = m*v;
  F_pis_spr = -k * (lo - (zo - z));
  F_pis_gas = A * ( N*R*T/(A*z) - mu*A*v/(A*z) );
  F_pis_tot = F_pis_gas + F_pis_spr;
  E = C*N*T;
  Q = A*h*(T_out - T);
  F_gas_pis = -F_pis_gas;
  phi = Q + F_gas_pis * v;
  P = P + F_pis_tot * dt;
  E = E + phi * dt;
  z = z + v * dt;
  t = t + dt;
  v = P/m;
  T = E/(C*N); #\iffalse
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= dt/2
    i = i+1;
    tSave(i) = t;
    zSave(i) = z;
    vSave(i) = v;
    TSave(i) = T;
  end #\fi@
end #\iffalse
%% Plot trajectory
close all;
subplot(2,1,1)
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave,zSave,'-','Color',cols(1,:));
xlabel('time {\it t}/s'); ylabel('position {\it z}/m'); hold on;
subplot(2,1,2)
plot(tSave,TSave-273.15,'-','Color',cols(2,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('temperature {\it T}/C'); # \fi@
