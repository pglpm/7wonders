%%%% Numerical time integration of piston-gas-spring
%% SI units used throughout
%% Vertical coordinate z, positive upward #\iffalse
clearvars; %\fi@

rho = 0.029; % molar mass kg/mol (air: 0.029)
A = 0.01^2; % cell area/m^2
V = 0.01^3; % cell volume/m^3
T = 293; % temperature
R = 8.31446; % molar gas constant
ncells = 10; % number of cells

dt = 0.0000001; % time step
t_end = dt*3000; % final time

t = 0; % initial time

N = ones(ncells, 1) * 1e5 * V / (R*T); % amount at 1 atm
N(1) = N(1) * 2; % amount in cell 1
P = zeros(ncells, 1); % momentum in cells is zero
P(1) = 0; % momentum in cell 1
Jleft = 0; % matter influx in cell 1
Jright = 0; % matter influx in last cell
Fleft = 0; % momentum influx into cell 1
Fright = 0; % momentum influx in last cell

%\iffalse
%% Plot & saving
%% adjust final time if not multiple of timestep
t_end = t_end + mod(t_end-t,dt);
%% Save values of all quantities at some steps during the simulation,
%% for subsequente analysis or plotting
%% (saving at all timesteps could be too costly)
nsaves = min(200, round(t_end/dt)); % number of timepoints to save during the simulation
%% Calculate time interval for saving
dsave = (t_end-t)/(nsaves-1);
if abs(dsave) < (dt)
  error('time interval between saves is smaller than timestep')
end
%% Initialize vectors to contain saved values
tSave = nan(nsaves,1);
NSave = nan(ncells, nsaves);
PSave = nan(ncells, nsaves);
prSave = nan(ncells, nsaves);
%% Save initial values
j = 1; % index that keeps count of savepoints
t0 = t;
tSave(1) = t;
NSave(:, 1) = N;
PSave(:, 1) = P;
prSave(:, 1) = R * T * N / V;
%% Numerical time integration
%\fi@
J = zeros(ncells+1, 1);
F = zeros(ncells+1, 1);

while t < t_end
  %% calculate matter fluxes between cells
  J(1) = Jleft;
  J(ncells+1) = Jright;
  F(1) = A * R * T * N(1)/V;
  F(ncells+1) = A * R * T * N(ncells)/V;
  for i = 2:ncells
    J(i) =  A/V/rho * (P(i-1) + P(i))/2;
    % F(i) = J(i) * (P(i-1) + P(i))/(N(i-1) + N(i)) + ...
    F(i) = 2*V/A * rho * J(i).^2/(N(i-1) + N(i)) + ...
        A/V * R * T * (N(i-1) + N(i))/2;
    % J(i) =  A/V/rho * (P(i-1) + P(i))/2;
    % Jold = J(i);
    % J(i) =  A/V/rho * (P(i-1) + P(i))/2;
    % PoverN = (P(i-1) + P(i))/(N(i-1) + N(i));
    % %PoverN(isnan(PoverN)) = 0;
    % %PoverN(isinf(PoverN)) = 0;
    % F(i) = Jold * PoverN + A/V * R * T * (N(i-1) + N(i))/2;
  end

  %% update contents of cells
  for i = 1:ncells
    N(i) = N(i) + (J(i) - J(i+1)) * dt;
    P(i) = P(i) + (F(i) - F(i+1)) * dt;
  end
  t = t + dt; %\iffalse
  %  [J F [N;0] [P;0]]

  %% Check whether to save & plot at this step
  if min(abs([0 dsave] - mod(t-t0, dsave))) <= dt/2
    j = j+1;
    tSave(j) = t;
    NSave(:, j) = N;
    PSave(:, j) = P;
    prSave(:, j) = R * T * N / V;
  end %\fi@
end %\iffalse
%% Plot trajectory
%close all;
subplot(4,1,1)
cols = get(0, 'DefaultAxesColorOrder');
plot(tSave, prSave(1, :),'-','Color',cols(1,:));
axis('tight'); ylim([0 max(prSave(1,:))]);
grid minor;
xlabel('time {\it t}/s'); ylabel('press. {\it 1}');
subplot(4,1,2)
plot(tSave, prSave(2, :),'-','Color',cols(1,:));
axis('tight'); ylim([0 max(prSave(2,:))]);
grid minor;
xlabel('time {\it t}/s'); ylabel('press. {\it 2}');
subplot(4,1,3); 
plot(tSave, prSave(3, :),'-','Color',cols(1,:));
xlabel('time {\it t}/s'); ylabel('press. {\it 3}');
axis('tight'); ylim([0 max(prSave(3,:))]);
grid minor
subplot(4,1,4)
plot(tSave, prSave(4, :),'-','Color',cols(1,:));
xlabel('time {\it t}/s'); ylabel('press. {\it 4}');
axis('tight'); ylim([0 max(prSave(4,:))]);
grid minor;
% plot(1:ncells, NSave(:, 1),'-', 1:ncells, NSave(:, end),'-'); axis('tight');
% xlabel('time {\it t}/s'); ylabel('amount {\it N}/mol'); %\fi@
% ylim([0 max(NSave(:,1))]);


[m, i1] = max(prSave(6,:));
[m, i0] = max(prSave(3,:));
(0.01 * 3)/(tSave(i1)-tSave(i0))