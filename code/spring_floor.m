%%% spring_floor.m
%% Simulation of two bodies connected by Hookean spring in 1D with friction
%% SI units used throughout
%% Coordinates x
%%%% Constants
ma = 1; % mass of object a
mb = 5; % mass of object b
g = 9.80665; % gravitational acceleration
k = 5; % spring constant
mu = 0.1; % friction coefficient
%%
Ga = -ma*g; % gravity supply on object a
Gb = -mb*g; % gravity supply on object b
%%
t1 = 30; % final time
dt = 0.001; % time step
%%%% STATE: x,v for a and b; initial conditions
t = 0; % initial time
xa = -3; % initial position of object a
xb = 3; % initial position of object a
va = 0; % initial velocity of object a
vb = 0; % initial velocity of object b
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
xaSave = nan(Nsaves,1); % position object a
xbSave = nan(Nsaves,1); % position object b
vaSave = nan(Nsaves,1); % velocity object a
vbSave = nan(Nsaves,1); % velocity object b
%% Save initial values
i = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
xaSave(1) = xa;
xbSave(1) = xb;
vaSave(1) = va;
vbSave(1) = vb;
%% Initialize plot
close all;
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), xaSave(1), 's','Color',cols(1,:)); axis('tight');
plot(tSave(1), xbSave(1), 'o','Color',cols(2,:));
xlabel('{\it y}/m'); ylabel('{\it x}/m'); hold on;
%% %@
%%%% Numerical time integration
%% loop
while t < t1
  %% We need y,z,vy,vz,Py,Pz,Fy,Fz for a and b (G constant)
  %% we have y,z,vy,vz
  %% find Py,Pz,Fy,Fz using constitutive relations
  Pa = ma*va;
  Pb = mb*vb;
  %% Hooke's law
  Fas = -k*(xa-xb);
  Fbs = -Fas;
  %% friction = mu * normal_force
  %% normal_force = gravity
  Fnorma = -Ga;
  Fnormb = -Gb;
  Ffra = -mu*sign(va)*Fnorma;
  Ffrb = -mu*sign(vb)*Fnormb;
  %%
  %% Drive forward in time
  %% update momentum
  Pa = Pa + (Fas + Ffra)*dt;
  Pb = Pb + (Fbs + Ffrb)*dt;
  %% update position
  xa = xa + va*dt;
  xb = xb + vb*dt;
  %% update time
  t = t + dt;
  %%
  %% Find new state for next iteration
  %% We need y,z,vy,vz
  %% we have y,z,Py,Pz
  %% find vy,vz using constitutive relations
  va = Pa/ma;
  vb = Pb/mb;
  %% %@
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    xaSave(i) = xa;
    xbSave(i) = xb;
    vaSave(i) = va;
    vbSave(i) = vb;
    plot(t, xa, 's','Color',cols(1,:));
    plot(t, xb, 'o','Color',cols(2,:));
    pause(0.001);
  end %@
end %@
%% Plot full trajectory
plot(tSave,xaSave,'-','Color',cols(1,:));
plot(tSave,xbSave,'-.','Color',cols(2,:)); %@
