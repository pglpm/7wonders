%%% _examblock.m
%% Last-Updated: 2024-04-10T22:32:15+0200
%%
%% SI units used throughout
%% Simulation of two bodies connected by non-Hookean spring in 2D
%% Coordinates (y,z)
m = 100; % mass of object a
z0 = 0;
v0 = -4.4272;
k = 2000;
h = 1000;
g = 9.8;
t0 = 0; % initial time
t1 = 5; % final time, can also be earlier than initial
dt = 0.001; % time step, negative if backward time integration %@
%% adjust final time if not multiple of timestep
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
tSave = nan(Nsaves,1); % time
zSave = nan(Nsaves,1); % position object a
vSave = nan(Nsaves,1); % position object a
FSave = nan(Nsaves,1); % position object a
%% Save initial values
i = 1; % index that keeps count of savepoints
tSave(1) = t0;
zSave(1) = z0;
vSave(1) = v0;
FSave(1) = -k*z0 - h*v0;
%% Initialize plot
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), zSave(1), 's','Color',cols(1,:)); axis('tight');
xlabel('{\it y}/m'); ylabel('{\it z}/m'); hold on;
%% %@
%% Numerical time integration
%% Initialize
t = t0;
z = z0;
v = v0;
P = m*v0;
G = -m*g;
%% loop
while (t < t1 && t0 < t1) || (t1 < t && t1 < t0) % possible backward time integr.
  %% update time
  t = t + dt;
  %% non-Hookean constitutive relation
  F = -k*z - h*v;
  %% update momentum
  P = P + (F + G)*dt;
  %% update velocity
  v = P/m;
  %% update position. We could also update first position, then velocity
  z = z + v*dt;
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    zSave(i) = z;
    vSave(i) = v;
    FSave(i) = F;
    plot(t, z, 's','Color',cols(1,:));
    pause(0.001);
  end %@
end %@
%% Plot full trajectory
plot(tSave,zSave,'-','Color',cols(1,:));
