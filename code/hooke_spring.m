%%% hooke_spring.m
%% Simulation of two bodies connected by Hookean spring in 2D
%% SI units used throughout
%% Coordinates (y,z)
%%%% Constants
ma = 2; % mass of object a
mb = 2; % mass of object b
g = 9.80665; % gravitational acceleration
k = 5; % spring constant
%%
Gya = 0; Gza = -ma*g*0; % gravity supply on object a
Gyb = 0; Gzb = -mb*g*0; % gravity supply on object b
%%
t1 = 10; % final time
dt = 0.001; % time step
%%%% STATE: y,z,vy,vz for a and b; initial conditions
t = 0; % initial time
ya = -3; za = 0; % initial position of object a
yb = 3; zb = 0; % initial position of object a
vya = 0; vza = 0; % initial velocity of object a
vyb = 0; vzb = 0; % initial velocity of object b
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
yaSave = nan(Nsaves,1); zaSave = nan(Nsaves,1); % position object a
ybSave = nan(Nsaves,1); zbSave = nan(Nsaves,1); % position object b
vyaSave = nan(Nsaves,1); vzaSave = nan(Nsaves,1); % velocity object a
vybSave = nan(Nsaves,1); vzbSave = nan(Nsaves,1); % velocity object b
%% Save initial values
i = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
yaSave(1) = ya; zaSave(1) = za;
ybSave(1) = yb; zbSave(1) = zb;
vyaSave(1) = vya; vzaSave(1) = vza;
vybSave(1) = vyb; vzbSave(1) = vzb;
%% Initialize plot
close all;
cols = get(0, 'DefaultAxesColorOrder');
plot(yaSave(1), zaSave(1), 's','Color',cols(1,:)); axis('tight');
plot(ybSave(1), zbSave(1), 'o','Color',cols(2,:));
xlabel('{\it y}/m'); ylabel('{\it z}/m'); hold on;
%% %@
%%%% Numerical time integration
%% loop
while t < t1
  %% We need y,z,vy,vz,Py,Pz,Fy,Fz for a and b (G constant)
  %% we have y,z,vy,vz
  %% find Py,Pz,Fy,Fz using constitutive relations
  Pya = ma*vya; Pza = ma*vza;
  Pyb = mb*vyb; Pzb = mb*vzb;
  %% Hooke's law
  Fyab = -k*(ya-yb);
  Fzab = -k*(za-zb);
  Fyba = -Fyab;
  Fzba = -Fzab;
  %%
  %% Drive forward in time
  %% update momentum
  Pya = Pya + (Fyab + Gya)*dt;
  Pza = Pza + (Fzab + Gza)*dt;
  Pyb = Pyb + (Fyba + Gyb)*dt;
  Pzb = Pzb + (Fzba + Gzb)*dt;
  %% update position
  ya = ya + vya*dt;
  za = za + vza*dt;
  yb = yb + vyb*dt;
  zb = zb + vzb*dt;
  %% update time
  t = t + dt;
  %%
  %% Find new state for next iteration
  %% We need y,z,vy,vz
  %% we have y,z,Py,Pz
  %% find vy,vz using constitutive relations
  vya = Pya/ma;  vza = Pza/ma;
  vyb = Pyb/mb;  vzb = Pzb/mb;
  %% %@
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    yaSave(i) = ya; zaSave(i) = za;
    ybSave(i) = yb; zbSave(i) = zb;
    vyaSave(i) = vya; vzaSave(i) = vza;
    vybSave(i) = vyb; vzbSave(i) = vzb;
    plot(ya, za, 's','Color',cols(1,:));
    plot(yb, zb, 'o','Color',cols(2,:));
    pause(0.001);
  end %@
end %@
%% Plot full trajectory
plot(yaSave,zaSave,'-','Color',cols(1,:));
plot(ybSave,zbSave,'-.','Color',cols(2,:)); %@
