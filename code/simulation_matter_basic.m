%%% Numerical simulation for amount of substance in volume

%% Initial values
t = 0; % s: initial time
N = 10; % mol: amount of substance

%% Boundary conditions
J = 4; % mol/s: net influx, constant
A = 0; % net/s: net supply, constant

%% Parameters for time loop
t1 = 2; % s: final time
dt = 0.01; % s: time step

%% numerical time integration
while t < t1
    N = N + (J + A) * dt;
    t = t + dt;
end

%% print final value
print(N)

