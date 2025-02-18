%%% Simulation of two bodies connected by Hookean spring in 2D
%% Coordinates (y,z)

%% Constants
ma = 2; % kg: mass of object a
mb = 2; % kg: mass of object b
g = 9.80665; % N/kg: gravitational acceleration
k = 5; % N/m: spring constant

%% Initial conditions
t = 0; % s: initial time
ya = -3; % m: initial position of object a
za = 0; % m
yb = 3; % m: initial position of object b
zb = 0; % m
vya = 0; % m/s: initial velocity of object a
vza = 10; % m/s
vyb = 0; % m/s: initial velocity of object b
vzb = 0; % m/s

%% Boundary conditions
Gya = 0; % N: gravity supply on object a
Gza = -ma * g; % N
Gyb = 0; % N: gravity supply on object b
Gzb = -mb * g; % N

%% Parameters for time loop
t1 = 5; % s: final time
dt = 0.001; % s: time step %@

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
clf;
plot(ya, za, 'sb')
xlabel('position y/m');
ylabel('position z/m');
grid on;
hold on;
plot(yb, zb, 'or') %@

%% State: ya, za, yb, zb, vya, vza, vyb, vzb
%% Numerical time integration
while t < t1
  %% constitutive relations
  Pya = ma * vya;
  Pza = ma * vza;
  Pyb = mb * vyb;
  Pzb = mb * vzb;
  %%
  Fyab = -k * (ya - yb);
  Fzab = -k * (za - zb);
  Fyba = -Fyab;
  Fzba = -Fzab;

  %% balances
  Pya = Pya + (Fyab + Gya) * dt;
  Pza = Pza + (Fzab + Gza) * dt;
  Pyb = Pyb + (Fyba + Gyb) * dt;
  Pzb = Pzb + (Fzba + Gzb) * dt;
  %%
  ya = ya + vya * dt;
  za = za + vza * dt;
  yb = yb + vyb * dt;
  zb = zb + vzb * dt;
  %%
  t = t + dt;

  %% constitutive relations
  vya = Pya / ma;
  vza = Pza / ma;
  vyb = Pyb / mb;
  vzb = Pzb / mb; %@

  %% plot
  if t > tplot
    plot(ya, za, 'sb')
    plot(yb, zb, 'or')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
