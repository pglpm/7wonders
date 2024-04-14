%%% idealgas2.m
%% Last-Updated: 2024-04-10T08:31:57+0200
%%
%% SI units used throughout
%% Simulation of ideal gas in 1D
%% Coordinate z
N = 0.2; % amount of ideal gas
r = 0.05; % radius of piston
A = pi * r^2; % area of piston
z0 = 0.6; % initial position of piston
v0 = 0.01; % initial velocity of piston
T0 = 273.15+25; % initial temperature of gas
h = 80; % heat conductivity
Fatm = -1e5 * A; % atmospheric force
%%
R = 8.31446261815; % gas constant
C = 20; % molar heat capacity
lambda = 18e-6 * (4/3 + 0.7); % viscosity
%%
t0 = 0; % initial time
t1 = 5; % final time, can also be earlier than initial
dt = 0.001; % time step, negative if backward time integration %@
%% adjust final time if not multiple of timestep
t1 = t1 + mod(t1-t0,dt);
%% check if timestep and time interval are consistent
if (t1-t0)*dt <= 0
  error('time interval inconsistent with timestep');
end
%% Save values of all quantities at some steps during the simulation,
%% for subsequente analysis or plotting
%% (saving at all timesteps could be too costly)
Nsaves = 200; % number of timepoints to save during the simulation
%% Calculate time interval for saving
dsave = (t1-t0)/(Nsaves-1);
if abs(dsave) < abs(dt)
  error('time interval between saves is smaller than timestep')
end
%% Initialize vectors to contain saved values
tSave = nan(Nsaves,1);
zSave = nan(Nsaves,1);
vSave = nan(Nsaves,1);
TSave = nan(Nsaves,1);
FSave = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
tSave(1) = t0;
zSave(1) = (N*R*T0 -A*lambda*v0)/Fatm;
vSave(1) = v0; %(N*R*T0 + Fatm*z0)/(A*lambda);
TSave(1) = T0;
FSave(1) = -Fatm;
%% Initialize plot
clf;
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), zSave(1), 'o','Color',cols(1,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('position {\it z}/m'); hold on;
%% %@
%% Numerical time integration
%% Initialize
t = t0;
v = v0;
z = (N*R*T0 -A*lambda*v0)/Fatm;
T = T0;
U = C*N*T0;
%% loop
while (t < t1 && t0 < t1) || (t1 < t && t1 < t0) % possible backward time integr.
  %% update time
  t = t + dt;
  %% constitutive relation for force on piston
  %% F = (N*R*T - A*lambda*v)/z;
  %% gives velocity
  F = -Fatm;
  %% constitutive relation for heat flux
  Q = h * (T0 - T) * z * (2*pi*r);
  %% update internal energy of gas
  U = U + (Q - F*v)*dt;
  %% update temperature of gas
  T = U/(C*N);
  %% update position of piston
  z = z + v*dt; %@
  v = (N*R*T - Fatm*z)/(A*lambda);
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    zSave(i) = z;
    vSave(i) = v;
    TSave(i) = T;
    FSave(i) = F;
    plot(t, z, 'o','Color',cols(1,:));
    pause(0.001);
  end %@
end %@
%% Plot full time dependence
plot(tSave,zSave,'-','Color',cols(1,:));
figure();
plot(tSave,TSave-273.15,'-','Color',cols(2,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('temperature {\it T}/C');
figure();
plot(tSave,(T0-TSave)*h.*zSave,'-','Color',cols(3,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('heat flux {\it Q}/W');
