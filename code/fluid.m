%% SI units used throughout
%% Simulation of ideal gas in 1D
%% Coordinate z
N = 0.01; % amount of ideal gas
A = 0.01; % area of piston
z0 = 0.51; % initial position of mass above piston
v0 = 0; % initial velocity of mass above piston
T0 = 273.15+25; % initial temperature of gas
Q = 0; % heat influx
m = 5; % mass above piston
P0 = 1e5; % atmospheric pressure
%%
R = 8.31446261815; % gas constant
C = 3*R/2; % molar heat capacity
H = 18e1 *4/3; % shear viscosity
g = 9.80665; % gravitational acceleration
G = -m*g; % supply of momentum to mass above piston
%%
t0 = 0; % initial time
t1 = 10; % final time, can also be earlier than initial
dt = 0.0001; % time step, negative if backward time integration %@
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
zSave(1) = z0;
vSave(1) = v0;
TSave(1) = T0;
FSave(1) = N*R*T0/z0 - A*H*v0/z0;
%% Initialize plot
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), zSave(1), 'o','Color',cols(1,:)); axis('tight');
xlabel('{\it t}/s'); ylabel('{\it z}/m'); hold on;
%% %@
%% Numerical time integration
%% Initialize
t = t0;
z = z0;
v = v0;
T = T0;
U = C*N*T0;
P = m*v0;
%% loop
while sign(dt)*t < sign(dt)*t1 % possible backward time integration
  %% update time
  t = t + dt;
  %% constitutive relation for force on mass above piston
  %% same as *minus* force on gas
  F = N*R*T/z - A*H*v/z;
  %% update internal energy of gas
  U = U + (Q - F*v)*dt;
  %% update temperature of gas
  T = U/(C*N);
  %% update momentum of mass above piston
  P = P + (F + G)*dt;
  %% update velocity of mass above piston
  v = P/m;
  %% update position of mass above piston
  z = z + v*dt; %@
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
%% Plot trajectory
plot(tSave,zSave,'-','Color',cols(1,:));
figure();
plot(tSave,TSave-273.15,'-','Color',cols(2,:)); axis('tight');
xlabel('{\it t}/s'); ylabel('{\it T}/C');