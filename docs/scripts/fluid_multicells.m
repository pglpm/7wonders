%%% Simulation of fluid pressure
%% Coordinates (t, x)

%% Constants
rho = 0.029; % kg/mol: molar mass (air: 0.029)
A = 0.01^2; % m^2:  cell area
V = 0.01^3; % m^3: cell volume
T = 293; % K: temperature
R = 8.31446; % N m/(K mol): molar gas constant
ncells = 10; % number of cells

%% Initial conditions
t = 0; % s: time
N = ones(ncells, 1) * 1e5 * V / (R * T); % amount at 1 atm
N(1) = N(1) * 2; % amount in cell 1
P = zeros(ncells, 1); % N s: momentum in cells is zero
P(1) = 0; % N s: momentum in cell 1
J = zeros(ncells+1, 1); % mol/s
F = zeros(ncells+1, 1); % N

%% Boundary conditions
Jleft = 0; % mol/s: matter influx in cell 1
Jright = 0; % mol/s: matter influx in last cell
Fleft = 0; % N: momentum influx into cell 1
Fright = 0; % N: momentum influx in last cell

%% Parameters for time loop
t1 = 0.0003; % s: final time
dt = 0.0000001; % s: time step
%@
%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
pressures = R * T * N / V;
for i = 1:4
subplot(4, 1, i);
plot(t, pressures(i), 'o', 'color', '#000000')
xlabel('{\it t}/s'); ylabel(['{\it p_', num2str(i), '}/K'])
axis('tight'); xlim([0, t1]); grid on; hold on
end %@

%% Numerical time integration
while t < t1
  %% calculate matter fluxes between cells
  J(1) = Jleft;
  J(ncells + 1) = Jright;
  F(1) = A * R * T * N(1) / V;
  F(ncells + 1) = A * R * T * N(ncells) / V;
  for i = 2:ncells
    J(i) =  A/V/rho * (P(i - 1) + P(i)) / 2;
    % F(i) = J(i) * (P(i-1) + P(i))/(N(i-1) + N(i)) + ...
    F(i) = 2 * V / A * rho * J(i).^2 / (N(i - 1) + N(i)) + ...
        A / V * R * T * (N(i - 1) + N(i)) / 2;
    % J(i) =  A/V/rho * (P(i-1) + P(i))/2;
    % Jold = J(i);
    % J(i) =  A/V/rho * (P(i-1) + P(i))/2;
    % PoverN = (P(i-1) + P(i))/(N(i-1) + N(i));
    % %PoverN(isnan(PoverN)) = 0;
    % %PoverN(isinf(PoverN)) = 0;
    % F(i) = Jold * PoverN + A/V * R * T * (N(i-1) + N(i))/2;
  end

  %% step forward in time with balance laws
  t = t + dt;
  for i = 1:ncells
    N(i) = N(i) + (J(i) - J(i + 1)) * dt;
    P(i) = P(i) + (F(i) - F(i + 1)) * dt;
  end
  %@
  %% plot
  if t > tplot
  pressures = R * T * N / V;
  for i = 1:4
      subplot(4, 1, i);
      plot(t, pressures(i), 'o', 'color', '#000000')
    end
    pause(0)
    tplot = tplot + dtplot;
  end %@
end
