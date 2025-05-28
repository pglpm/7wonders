from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Simulation of ideal gas & mass piston with leak
## Coordinates (t, z)

## Constants
R = 8.31446261815   # J/(K*mol): molar gas constant
g = 9.8             # N/kg: gravitational acceleration
C = 20              # J/(K*mol): molar heat capacity
mu = 0.00004        # N*s/m**2: gas viscosity
h = 8000            # J/(K*m**2): heat-transfer coefficient

Text = 373.15 + 23  # K: temperature of environment
A = 0.1**2           # m**2: area of piston
m = 50              # kg: mass of piston
Fatm = -100000 * A  # N: force on piston by atmosphere
k = 100             # N/m: elastic constant of spring

## Initial conditions. State: (z, v, T)
t = 0            # s: initial time
z = 0.15         # m: initial position of piston
v = 0            # m/s: initial velocity of piston
T = 273.15 + 23  # K: initial temperature of gas
N = 0.04         # mol: amount of ideal gas

## Boundary conditions
G = -m*g  # N: gravity supply of momentum to piston
J = -0.000   # mol/s: gas leak

## Parameters for time loop
t1 = 10      # s: final time
dt = 0.0001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
figure
subplot(2, 1, 1); plot(t, z, '.b')
xlim([0, t1])
xlabel('${\it t}$/s'); ylabel('${\it z}$/m')
axis('tight'); grid(True); 
subplot(2, 1, 2); plot(t, T, '.r')
xlim([0, t1])
xlabel('${\it t}$/s'); ylabel('${\it T}$/K')
axis('tight'); grid(True);  #@

## Numerical time integration
while t < t1 && N > 0:
  ## constitutive relations
  Fgas = -(R * N * T / z -  mu * A * v / z)  # ideal-gas law
  Q = A * h * (Text - T)                     # law of cooling
  Phi = Q + Fgas * v                         # energy influx for gas
  E = C * N * T                              # internal energy of ideal gas
  P = m * v                                  # Newton's formula for momentum
  Fspr = -k * z                              # Hooke's law
  F = -Fgas + Fatm + Fspr                    # momentum influx for piston

  ## step forward in time with balance laws
  t = t + dt
  E = E + Phi * dt
  P = P + (F + G) * dt
  N = N + J * dt
  z = z + v * dt

  ## constitutive relations: calculate state
  T = E / (C * N)
  v = P / m  #@

  ## plot
  if t > tplot:
    subplot(2, 1, 1); plot(t, z, '.b')
    subplot(2, 1, 2); plot(t, T, '.r')
    # pause(0.0001) # comment for matplotlib.online
    tplot = tplot + dtplot

plt.show()
