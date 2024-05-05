%%% jumping_spring.m
%% Simulation of two bodies connected by Hookean spring in 1D
%% moving vertically, with floor
%% SI units used throughout
%% Coordinates (z)
%%%% Constants
ma = 2; % mass of object a
mb = 1; % mass of object b
g = 9.80665; % gravitational acceleration
k = 100; % spring constant
lo = 2; % spring natural length
%%
Gaz = -ma*g; % gravity supply on object a
Gbz = -mb*g; % gravity supply on object b
%%
t1 = 10; % final time
dt = 0.001; % time step
%%%% STATE: z,vz for a and b; initial conditions
t = 0; % initial time
za = 1; % initial position object a
zb = 0; % initial position object b
vaz = 0; % initial velocity object a
vbz = 0; % initial velocity object b
%% %@
%%%% Plot & saving
%% adjust final time if not multiple of timestep
t1 = t1 + mod(t1-t,dt);
%% Save values of all quantities at some steps during the simulation,
%% for subsequente analysis or plotting
%% (saving at all timesteps could be too costly)
Nsaves = 200; % number of timepoints to save during the simulation
%% Calculate time interval for saving
dsave = (t1-t)/(Nsaves-1);
if abs(dsave) < abs(dt)
  error('time interval between saves is smaller than timestep')
end
%% Initialize vectors to contain saved values
tSave = nan(Nsaves,1); % time
zaSave = nan(Nsaves,1); % position object a
zbSave = nan(Nsaves,1); % position object b
vazSavez = nan(Nsaves,1); % velocity object a
vbzSavez = nan(Nsaves,1); % velocity object b
%% Save initial values
i = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
zaSave(1) = za;
zbSave(1) = zb;
vzaSave(1) = vaz;
vzbSave(1) = vbz;
%% Initialize plot
close all;
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), zaSave(1), 's','Color',cols(1,:)); axis('tight');
plot(tSave(1), zbSave(1), 'o','Color',cols(2,:));
xlabel('{\it t}/s'); ylabel('{\it z}/m'); hold on;
%% %@
%%%% Numerical time integration
%% loop
while t < t1
  Paz = ma*vaz;
  Pbz = mb*vbz;
  %% Hooke's law
  Fasz = -k*(za-zb-lo);
  Fbsz = -Fasz;
  %% normal force
  Fverta = Fasz + Gaz + Paz/dt;
  if za <= 0 && Fverta < 0
    Fnaz = -Fverta;
  else
    Fnaz = 0;
  end
  Fvertb = Fbsz + Gbz + Pbz/dt;
  if zb <= 0 && Fvertb < 0
    Fnbz = -Fvertb;
  else
    Fnbz = 0;
  end
  %%
  %% Drive forward in time
  %% update momentum
  Paz = Paz + (Fasz + Fnaz + Gaz)*dt;
  Pbz = Pbz + (Fbsz + Fnbz + Gbz)*dt;
  %% update position
  za = za + vaz*dt;
  zb = zb + vbz*dt;
  %% update time
  t = t + dt;
  %%
  vaz = Paz/ma;
  vbz = Pbz/mb;
  %% %@
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    zaSave(i) = za;
    zbSave(i) = zb;
    vzaSave(i) = vaz;
    vzbSave(i) = vbz;
    plot(t, za, 's','Color',cols(1,:));
    plot(t, zb, 'o','Color',cols(2,:));
    pause(0.001);
  end %@
end %@
%% Plot full trajectory
plot(tSave,zaSave,'-','Color',cols(1,:)); axis('tight');
plot(tSave,zbSave,'-.','Color',cols(2,:)); %@
