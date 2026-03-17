%%% Numerical simulation of football bouncing on ground
%% Coordinates (t, z)

%% Constants
m = 0.43;  % kg: mass-energy football
R = 0.11;  % m: radius
g = 9.8;   % N/kg: gravitational acceleration
k = 1e5;   % N/m: elastic constant
C = 100;   % N s/m: distance between centres of objects

%% Initial conditions
t = 0;  % s: time
z = 0.14;  % m: position 
v = -4.12;  % m/s: velocity

%% Boundary conditions
G = -m * g;  % N: momentum supply

%% Time-iteration parameters
t1 = 0.02;        % s: final time
dt = 0.000001;  % s: time step %@

%% Plotting
dtplot = t1/1000;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
subplot(4, 1, 1); plot(t, z, '.', 'color', '#000000')
plot([0, t1], [R, R], '--', 'color', '#BBBBBB')
xlabel('{\it t}/s'); ylabel('{\it z}/m')
axis('tight'); xlim([0, t1]); grid on; hold on
subplot(4, 1, 2); plot(t, v, '.', 'color', '#EE6677')
xlabel('{\it t}/s'); ylabel('{\it v}/(m/s)')
axis('tight'); xlim([0, t1]); grid on; hold on
subplot(4, 1, 3); plot(t, -g, '.', 'color', '#AA3377')
xlabel('{\it t}/s'); ylabel('{\it a}/(m/s^2)')
axis('tight'); xlim([0, t1]); grid on; hold on
subplot(4, 1, 4); plot(t, 0, '.', 'color', '#4477AA')
plot([0, t1], m * g * [1, 1], '--', 'color', '#66CCEE')
xlabel('{\it t}/s'); ylabel('{\it F}/N')
axis('tight'); xlim([0, t1]); grid on; hold on %@

%% Numerical time integration
while t < t1
  %% constitutive relations
  P = m * v;
  %% constit. relation for F
  if z >= R
    F = 0;
  else
    F = -k * (z - R) - C * v;
  end

  %% save v to plot acceleration
  v0 = v;
  %% step forward in time with balance laws
  t = t + dt;
  P = P + (F + G) * dt;
  z = z + v * dt;

  %% constit. relations: find new state variables
  v = P / m;

  %% calculate acceleration for plot
  a = (v - v0) / dt;  %@

  %% plot
  if t > tplot
    subplot(4, 1, 1); plot(t, z, '.', 'color', '#000000')
    subplot(4, 1, 2); plot(t, v, '.', 'color', '#EE6677')
    subplot(4, 1, 3); plot(t, a, '.', 'color', '#AA3377')
    subplot(4, 1, 4); plot(t, F, '.', 'color', '#4477AA')
    %pause(0)
    tplot = tplot + dtplot;
  end %@
end
