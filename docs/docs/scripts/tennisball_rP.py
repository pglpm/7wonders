### Numerical simulation of object motion with gravity
## Coordinates (t, x, y, z)
from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt

## Constants
m = 0.06 # kg: tennis ball's mass-energy
g = 9.8 # N/kg: gravitational acceleration

## Initial conditions
t = 0 # s: initial time
r = vector([0, 0, 5]) # m: initial position vector
P = vector([0, 0, 0.42]) # N s: initial momentum vector

## Boundary conditions
F = vector([0, 0, 0]) # N: momentum influx
G = -m * g * vector([0, 0, 1]) # N: momentum supply

## Time-iteration parameters
t1 = 2 # s: final time
dt = 0.01 # s: time step

## Plotting
dtplot = t1/360 # time interval between plots
tplot = dtplot # time for next plot
figure()
subplot(2, 1, 1); plot(t, P[2], '.b')
xlim([0, t1])
xlabel('time ${\it t}$/s'); ylabel('z-momentum ${\it P_z}$/(Ns)')
grid(True)
subplot(2, 1, 2); plot(t, r[2], '.r')
xlim([0, t1])
xlabel('time ${\it t}$/s'); ylabel('z-coord. ${\it z}$/m')
grid(True)

## Numerical time integration
while t < t1:
  ## constitutive relations
  v = P / m

  ## step forward in time with balance laws
  t = t + dt
  P = P + (F + G) * dt
  r = r + v * dt

  ## plot
  if t > tplot:
    subplot(2, 1, 1); plot(t, P[2], '.b')
    subplot(2, 1, 2); plot(t, r[2], '.r')
    tplot = tplot + dtplot

plt.show()
