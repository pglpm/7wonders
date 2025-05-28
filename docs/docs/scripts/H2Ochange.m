%%% H2Ochange.m
%% Numerical simulation of change of H2O amount in a volume
%% (base SI units used throughout)
clearvars; % Make sure all values are new
cols = get(0, 'DefaultAxesColorOrder'); % colours

%% Initial values
N = 10; % initial amount of H2O (mol)
t = 0; % initial time

%% Constant values
J = -2; % flux of H2O (mol/s)
A = 3; % supply of H2O (mol/s)

tfinal = 10; % final time
dt = 0.01; % time step

%% Save the values at each step
i = 1;
NSave(i) = N;
tSave(i) = t;

%% Numerical time integration: loop
while t < tfinal
  N = N + J * dt + A * dt; % update amount of H2O
  t = t + dt; % update time

  i = i + 1;
  NSave(i) = N;
  tSave(i) = t;
end

%% Plot change in time
plot(tSave, NSave, 'Color', cols(1,:)); axis('tight');
