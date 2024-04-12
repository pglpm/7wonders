%%% idealgas_piston.m
%% Last-Updated: 2024-04-12T23:56:01+0200
%%
%% SI units used throughout
%% Simulation of ideal gas & mass piston in 1D
%% Coordinate z
m = 10; % mass of piston
N = 0.04; % amount of ideal gas
A = 0.1^2; % area of piston
g = 9.80665; % gravitational acceleration
R = 8.31446261815; % molar gas constant
C = 20; % molar heat capacity
lambda = 0.00004; % gas viscosity
h = 8000; % heat conductivity
Tenv = 273.15 + 23; % temperature of environment
Fatm = -100000*A; % force on piston by atmosphere
%%
%% STATE: z, v, T
z0 = 0.1; % initial position of piston
v0 = 0; % initial velocity of piston
T0 = 273.15 + 23; % initial temperature of gas
%%
t0 = 0; % initial time
t1 = 1; % final time
dt = 0.0001; % time step
%% Initialize state for numerical time integration
t = t0;
z = z0;
v = v0;
T = T0;
%%
G = -m*g; % gravity supply of momentum to piston
%% %@
%% Plot & saving
%% adjust final time if not multiple of timestep
t1 = t1 + mod(t1-t0,dt);
%% Save values of all quantities at some steps during the simulation,
%% for subsequente analysis or plotting
%% (saving at all timesteps could be too costly)
Nsaves = 200; % number of timepoints to save during the simulation
%% Calculate time interval for saving
dsave = (t1-t0)/(Nsaves-1);
if dsave < dt
  error('time interval between saves is smaller than timestep')
end
%% Initialize vectors to contain saved values
tSave = nan(Nsaves,1);
zSave = nan(Nsaves,1);
vSave = nan(Nsaves,1);
TSave = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
tSave(1) = t0;
zSave(1) = z0;
vSave(1) = v0;
TSave(1) = T0;
%% Initialize plot
close all;
subplot(2,1,1)
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), zSave(1), 'o','Color',cols(1,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('position {\it z}/m'); hold on;
%% %@
%% Numerical time integration
%% loop
while t < t1
  %% We need P,Fmass,z,v,U,Fgas,Q (G constant)
  %% we have z,v,T
  %% find P,Fpis,U,Q,Fgas using constitutive relations
  P = m*v;
  Fgas = -(N*R*T/z - A*lambda*v/z);
  Fpis = -Fgas + Fatm;
  U = C*N*T;
  Q = A*z*h*(Tenv - T);
  %%
  %% Drive forward in time
  %% update momentum of piston
  P = P + (Fpis + G)*dt;
  %% update position of piston
  z = z + v*dt;
  %% update internal energy of gas
  U = U + (Q + Fgas*v)*dt;
  %% update time
  t = t + dt;
  %%
  %% Find new state for next iteration
  %% We need z,v,T
  %% we have P,z,U
  %% find v,T using constitutive relations
  v = P/m;
  T = U/(C*N);
  %% %@
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= dt/2
    i = i+1;
    tSave(i) = t;
    zSave(i) = z;
    vSave(i) = v;
    TSave(i) = T;
    plot(t, z, 'o','Color',cols(1,:));
    pause(0.001);
  end %@
end %@
%% Plot trajectory
plot(tSave,zSave,'-','Color',cols(1,:));
subplot(2,1,2)
plot(tSave,TSave-273.15,'-','Color',cols(2,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('temperature {\it T}/C');
