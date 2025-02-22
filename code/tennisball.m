%%% Numerical simulation of object motion in 2D with gravity
%% Coordinates (y, z)

%% Constants
m = 0.059; % kg: tennis ball's mass
g = 9.8; % N/kg: gravitational acceleration

%% Initial conditions
t = 0; % s: initial time
y = 0; % m: initial position
z = 2; % m
Py = 3; % N s: initial momentum
Pz = 0.75; % N s

%% Boundary conditions
Fy = 0; % N: momentum influx
Fz = 0; % N
Gy = 0; % N: momentum supply
Gz = -m * g;

%% Time-iteration parameters
t1 = 2; % s: final time
dt = 0.01; % s: time step %@

%% Plotting
dtplot = t1/360; % time interval between plots
tplot = dtplot; % time for next plot
clf;
plot(y, z, 'b.')
xlim([0, 110]);
ylim([0, 15]);
xlabel('position y/m');
ylabel('position z/m');
grid on;
hold on; %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  vy = Py/m;
  vz = Pz/m;

  %% step forward in time with balance laws
  t = t + dt;
  Py = Py + (Fy + Gy) * dt;
  Pz = Pz + (Fz + Gz) * dt;
  y = y + vy * dt;
  z = z + vz * dt; %@

  %% plot
  if t > tplot
    plot(y, z, '.b')
    pause(0)
    tplot = tplot + dtplot;
  end %@
end

%% Print final values
print(y)
print(z)
print(Py)
print(Pz)
