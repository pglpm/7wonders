%%% tennisball.m
%% Last-Updated: 2024-04-13T13:02:58+0200
%% Numerical simulation of object motion in 2D with gravity
%% (base SI units used throughout)
%% Coordinates (y,z)
%% Parameters
m = 0.059; % tennis ball's mass
%%
%% Initial values
t0 = 0; % initial time
y0 = 0; z0 = 2; % initial position
Py0 = 3; Pz0 = 0.75; % initial momentum
%%
t1 = t0 + 2; % final time
dt = 0.01; % time step
%%
%% Initialize values for loop
t = t0;
y = y0; z = z0;
Py = Py0; Pz = Pz0;
%%
Fy = 0; Fz = 0; % momentum influx (constant)
Gy = 0; Gz = -0.579; % momentum supply (constant)
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
if abs(dsave) < abs(dt)
  error('time interval between saves is smaller than timestep')
end
%% Initialize vectors to contain saved values
tSave = nan(Nsaves,1);
ySave = nan(Nsaves,1); zSave = nan(Nsaves,1);
PySave = nan(Nsaves,1); PzSave = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
tSave(i) = t;
ySave(i) = y; zSave(i) = z;
PySave(i) = Py; PzSave(i) = Pz;
%% Initialize plot
cols = get(0, 'DefaultAxesColorOrder');
plot(ySave(1), zSave(1), '.', 'Color', cols(1,:)); axis('tight');
xlabel('y/m'); ylabel('z/m'); hold on;
%% %@
%% Numerical time integration
%% loop
while t < t1
  %% We need Py,Px,y,z,vy,vz
  %% we have y,z,Py,Pz
  %% find vy,vz using constitutive relations
  vy = Py/m; vz = Pz/m;
  %%
  %% Drive forward in time
  %% update momentum
  Py = Py + (Fy + Gy)*dt;
  Pz = Pz + (Fz + Gz)*dt;
  %% update position
  y = y + vy*dt;
  z = z + vz*dt;
  %% update time
  t = t + dt;
  %% %@
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    ySave(i) = y; zSave(i) = z;
    vySave(i) = vy; vzSave(i) = vz;
    PySave(i) = Py; PzSave(i) = Pz;
    plot(y, z, '.', 'Color', cols(1,:));
    pause(0.001);
  end %@
end %@
%% Plot full trajectory
plot(ySave, zSave, 'Color', cols(1,:)); axis('tight'); %@
