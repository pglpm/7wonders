### Numerical simulation of relativistic motion with gravity
## Coordinates (t, x, y, z)
from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt

## Constants
m = 0.06       # kg: tennis ball's mass-energy
g = 9.8        # N/kg: gravitational acceleration
c = 299792458  # m/s: speed of light

## Initial conditions
t = 0                      # s: initial time
r = vector([0, 0, 0])      # m: initial position vector
P = vector([0, 0, 1.8e6])  # N s: initial momentum vector

## Boundary conditions
F = vector([0, 0, 0])           # N: momentum influx
G = -m * g * vector([0, 0, 1])  # N: momentum supply

## Time-iteration parameters
t1 = 2e8  # s: final time
dt = 1e6  # s: time step

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
figure()
subplot(2, 1, 1); plot(t, P[2], '^', color='#4477AA')
xlim([0, t1])
xlabel('time ${\it t}$/s'); ylabel('z-momentum ${\it P_z}$/(Ns)')
grid(True)
subplot(2, 1, 2); plot(t, r[2], 'o', color='#EE6677')
xlim([0, t1])
xlabel('time ${\it t}$/s'); ylabel('z-coordinate ${\it z}$/m')
grid(True)

## Numerical time integration
while t < t1:
  
  ## constitutive relations
  v = P / sqrt(m**2 + norm(P)**2 / c**2)
  
  ## step forward in time with balance laws
  t = t + dt
  P = P + (F + G) * dt
  r = r + v * dt
  
  ## plot
  if t > tplot:
    subplot(2, 1, 1); plot(t, P[2], '^', color='#4477AA')
    subplot(2, 1, 2); plot(t, r[2], 'o', color='#EE6677')
    tplot = tplot + dtplot

plt.show()
