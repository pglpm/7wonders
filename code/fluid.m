%% SI units used throughout
%% Simulation of ideal gas in 1D
%% Coordinate z
N = 1; % amount of matter
L0 = 1; % initial volume
T0 = 273.15+25; % initial temp
Q = 0; % heat flux
%%
R = 8.31446261815; % gas constant
C = 3*R/2; % molar heat capacity
H = 18e-6; % shear viscosity
%%
t0 = 0; % initial time
t1 = 10; % final time, can also be earlier than initial
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
tSave = nan(Nsaves,1); % time
yaSave = nan(Nsaves,1); zaSave = nan(Nsaves,1);
ybSave = nan(Nsaves,1); zbSave = nan(Nsaves,1);
PyaSave = nan(Nsaves,1); PzaSave = nan(Nsaves,1);
PybSave = nan(Nsaves,1); PzbSave = nan(Nsaves,1);
%% Save initial values
i = 1; % index that keeps count of savepoints
tSave(1) = t0;
yaSave(1) = ya0; zaSave(1) = za0;
ybSave(1) = yb0; zbSave(1) = zb0;
PyaSave(1) = ma*vya0; PzaSave(1) = ma*vza0;
PybSave(1) = mb*vyb0; PzbSave(1) = mb*vzb0;
%% Initialize plot
cols = get(0, 'DefaultAxesColorOrder');
plot(yaSave(1), zaSave(1), 's','Color',cols(1,:)); axis('tight');
plot(ybSave(1), zbSave(1), 'o','Color',cols(1,:)); axis('tight');
xlabel('{\it y}/m'); ylabel('{\it z}/m'); hold on;
%% %@
%% Numerical time integration
%% Initialize
t = t0;
ya = ya0; za = za0;
yb = yb0; zb = zb0;
vya = vya0; vza = vza0;
vyb = vyb0; vzb = vzb0;
Pya = ma*vya0; Pza = ma*vza0;
Pyb = mb*vyb0; Pzb = mb*vzb0;
%% loop
while sign(dt)*t < sign(dt)*t1 % possible backward time integration
  %% update time
  t = t + dt;
  %% non-Hookean constitutive relation
  l = norm([ya-yb, za-zb]); % present length
  if l < ln
    Fyab = 0;
    Fzab = 0;
  else
    Fyab = -k*(ya-yb)*(l-ln)/l;
    Fzab = -k*(za-zb)*(l-ln)/l;
  end
  %% update momentum
  Fyba = -Fyab;
  Fzba = -Fzab;
  Pya = Pya + (Fyab + Gya)*dt;
  Pza = Pza + (Fzab + Gza)*dt;
  Pyb = Pyb + (Fyba + Gyb)*dt;
  Pzb = Pzb + (Fzba + Gzb)*dt;
  %% update velocity
  vya = Pya/ma;
  vza = Pza/ma;
  vyb = Pyb/mb;
  vzb = Pzb/mb;
  %% update position
  ya = ya + vya*dt;
  za = za + vza*dt;
  yb = yb + vyb*dt;
  zb = zb + vzb*dt; %@
  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= abs(dt)/2
    i = i+1;
    tSave(i) = t;
    yaSave(i) = ya; zaSave(i) = za;
    ybSave(i) = yb; zbSave(i) = zb;
    PyaSave(i) = Pya; PzaSave(i) = Pza;
    PybSave(i) = Pyb; PzbSave(i) = Pzb;
    plot(ya, za, 's','Color',cols(1,:));
    plot(yb, zb, 'o','Color',cols(2,:));
    pause(0.001);
  end %@
end %@
%% Plot trajectory
plot(yaSave,zaSave,'-','Color',cols(1,:));
plot(ybSave,zbSave,'-.','Color',cols(2,:)); %@
