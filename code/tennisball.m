%% (base SI units used throughout)
%% Numerical simulation of object motion in 2D with gravity
%% Coordinates (y,z)
%% Parameters and initial values:
t0 = 0; % initial time
t1 = t0 + 2; % final time
Py0 = 3; Pz0 = 0.75; % initial momentum
y0 = 0; z0 = 2; % initial position
Fy = 0; Fz = 0; % momentum influx (constant)
Gy = 0; Gz = -0.579; % momentum supply (constant)
m = 0.059; % tennis ball's mass
dt = 0.01; % time step %@
%% adjust final time if not multiple of timestep
t1 = t1 + mod(t1-t0,dt);
%% check if timestep and time interval are consistent
%% (we can integrate backward in time)
if (t1-t0)*dt <= 0
  error('time interval inconsistent with timestep');
end
%%
%% We save values of all quantities at some steps during the simulation,
%% in case we want to do some analysis or plotting afterwards.
%% Saving at all timesteps could be too costly in terms of memory
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
vySave = nan(Nsaves,1); vzSave = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
tSave(i) = t0;
ySave(i) = y0; zSave(i) = z0;
PySave(i) = Py0; PzSave(i) = Pz0;
vySave(i) = Py0/m; vzSave(i) = Pz0/m;
%% Initialize plot
cols = get(0, 'DefaultAxesColorOrder');
plot(ySave(1), zSave(1), '.', 'Color', cols(1,:)); axis('tight');
xlabel('y/m'); ylabel('z/m'); hold on; %@
%%
%% Numerical time integration
%% initialize
t = t0;
y = y0; z = z0;
Py = Py0; Pz = Pz0;
vy = Py/m; vz = Pz/m;
%% loop
while sign(dt)*t < sign(dt)*t1 % this check allows for backward time integration
  %% update time
  t = t + dt;
  %% update momentum
  Py = Py + (Fy + Gy)*dt;
  Pz = Pz + (Fz + Gz)*dt;
  %% update velocity (from constitutive relation P=mv)
  vy = Py/m;
  vz = Pz/m;
  %% update position
  y = y + vy*dt;
  z = z + vz*dt; %@
  %% Check whether we save & plot at this step
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
plot(ySave, zSave, 'Color', cols(1,:)); axis('tight'); %@
