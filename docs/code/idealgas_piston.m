% %% idealgas_piston.m
% % Simulation of ideal gas & mass piston in 1D
% % SI units used throughout
% % Coordinate z
% %%% Constants
m = 10; % mass of piston / kg
N = 0.04; % amount of ideal gas / mol
A = 0.1^2; % area of piston / m^2
g = 9.8; % gravitational acceleration / (N/kg)
R = 8.31446261815; % molar gas constant / (J/(K*mol))
C = 20; % molar heat capacity / (J/(K*mol))
mu = 0.00004; % gas viscosity / (N*s/m^2)
h = 8000; % heat-transfer coefficient / (J/(K*m^2))
Tex = 373.15 + 23; % temperature of environment / K
Fatm = -100000*A; % force on piston by atmosphere / N
% %
G = -m*g; % gravity supply of momentum to piston / N
% %
t1 = 1; % final time / s
dt = 0.0001; % time step / s
% %%% STATE: z, v, T; initial conditions
t = 0; % initial time / s
z = 0.15; % initial position of piston / m
v = 0; % initial velocity of piston / (m/s)
T = 273.15 + 23; % initial temperature of gas / K
% % %@
% % Plot & saving
% % adjust final time if not multiple of timestep
t1 = t1 + mod(t1-t,dt);
% % Save values of all quantities at some steps during the simulation,
% % for subsequente analysis or plotting
% % (saving at all timesteps could be too costly)
Nsaves = 200; % number of timepoints to save during the simulation
% % Calculate time interval for saving
dsave = (t1-t)/(Nsaves-1);
if abs(dsave) < (dt)
  error('time interval between saves is smaller than timestep')
end
% % Initialize vectors to contain saved values
tSave = nan(Nsaves,1);
zSave = nan(Nsaves,1);
vSave = nan(Nsaves,1);
TSave = nan(Nsaves,1);
% % Save initial values
i = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
zSave(1) = z;
vSave(1) = v;
TSave(1) = T;
% % Initialize plot
close all;
subplot(2,1,1)
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave(1), zSave(1), 'o','Color',cols(1,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('position {\it z}/m'); hold on;
% % %@
% % Numerical time integration
% % loop
while t < t1
  % % We need P,Fpg,z,v,E,Fgp,Qbot (G constant)
  % % we have z,v,T
  % % find P,Fpg,E,Qbot,Fgp using constitutive relations
  P = m*v;
  Fgp = -(N*R*T/z - A*mu*v/z);
  Fpg = -Fgp;
  E = C*N*T;
  Qbot = A*h*(Tex - T);
  % %
  % % Drive forward in time
  % % update momentum of piston
  P = P + (Fpg + Fatm + G)*dt;
  % % update position of piston
  z = z + v*dt;
  % % update internal energy of gas
  E = E + (Qbot + Fgp*v)*dt;
  % % update time
  t = t + dt;
  % %
  % % Find new state for next iteration
  % % We need z,v,T
  % % we have P,z,E
  % % find v,T using constitutive relations
  v = P/m;
  T = E/(C*N);
  % % %@
  % % Check whether to save & plot at this step
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
% % Plot trajectory
plot(tSave,zSave,'-','Color',cols(1,:));
subplot(2,1,2)
plot(tSave,TSave-273.15,'-','Color',cols(2,:)); axis('tight');
xlabel('time {\it t}/s'); ylabel('temperature {\it T}/C');  %@
