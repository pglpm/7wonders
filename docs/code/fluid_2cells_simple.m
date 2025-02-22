%% Numerical simulation of gas
%% SI units used throughout
clearvars;

rho = 0.029; % molar mass kg/mol (air)
A = 0.01^2; % cell area/m^2
V = 0.01^3; % cell volume/m^2
T = 293; % temperature 20 degrees
R = 8.31446; % molar gas constant

t = 0; % initial time
dt = 0.0000001; % time step
t_end = dt*1500; % final time

N1 = 10; % initial amount/mol in cell 1
N2 = 0.5; % initial amount/mol in cell 2
P1 = 0; % initial x-momentum in cell 1
P2 = 0; % initial x-momentum in cell 2
J1 = 0; % matter flux into cell 1
J3 = 0; % matter flux out of cell 2

J2 = A/V * (P1 + P2)/(2 * rho);

F1 = A/V * R * T * N1;
F2 = V/A * 2 * rho/(N1 + N2) * J2.^2 + A/V * R * T * (N1 + N2)/2;
F3 = A/V * R * T * N2;




clf;
subplot(2,1,1)
plot(t, N1, '.', 'Color','blue');
xlim([0, t_end]); ylim([0.3, 1.1]);
xlabel('time t/s'); ylabel('amount in cell 1: N1/mol');
hold on
subplot(2,1,2)
plot(t, N2, '.', 'Color','red');
xlim([0, t_end]); ylim([0.3, 1.1]);
xlabel('time t/s'); ylabel('amount in cell 2: N2/mol');
hold on

%% Numerical time integration
while t < t_end


    N1 = N1 + (J1 - J2) * dt;
    N2 = N2 + (J2 - J3) * dt;
    
    P1 = P1 + (F1 - F2) * dt;
    P2 = P2 + (F2 - F3) * dt;
    
    t = t + dt;

    J2 = A/V * (P1 + P2)/(2 * rho);
    
    F1 = A/V * R * T * N1;
    F2 = V/A * 2 * rho/(N1 + N2) * J2.^2 + A/V * R * T * (N1 + N2)/2;
    F3 = A/V * R * T * N2;
    
  subplot(2,1,1)
  plot(t, N1, '.', 'Color','blue');
  subplot(2,1,2)
  plot(t, N2, '.', 'Color','red');
  %drawnow
end
subplot(2,1,1);
grid minor;
subplot(2,1,2);
grid minor;
