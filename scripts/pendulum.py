from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Simulation of pendulum in 2D
## Coordinates (t, y, z)

## Constants
m = 2    # kg: mass of object
g = 9.8  # N/kg: gravitational acceleration
k = 50   # N/m: spring constant

## Initial conditions
t = 0               # s: initial time
r = vector([0, -0.5])     # m: initial position of object
v = vector([1, 0])  # m/s: initial velocity of object

## Boundary conditions
G = -m * g * vector([0, 1]) # N: gravity supply on object

## Parameters for time loop
t1 = 10        # s: final time
dt = 0.000001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
figure
plot(0, 0, 'x', color='#000000')
xlim([-1, 1]); ylim([-1, 1])
grid(True); gca().set_aspect("equal", adjustable="box")
plot([0, r[0]], [0, r[1]], '-', color='#4477AA')
plot(r[0], r[1], 'o', color='#EE6677')
xlabel('${\it y}$/m'); ylabel('${\it z}$/m')

## State: r, v
## Numerical time integration
while t < t1:

  ## constitutive relations
  P = m * v
  F = -k * r

  ## balances
  t = t + dt
  P = P + (F + G) * dt
  r = r + v * dt

  ## constitutive relations
  v = P / m #@

  ## plot
  if t > tplot:
if not "pyodide" in sys.modules: clf()
    plot(0, 0, 'x', color='#000000')
    xlim([-1, 1]); ylim([-1, 1])
    grid(True); gca().set_aspect("equal", adjustable="box")
    plot([0, r[0]], [0, r[1]], '-', color='#4477AA')
    plot(r[0], r[1], 'o', color='#EE6677')
    xlabel('${\it y}$/m'); ylabel('${\it z}$/m')
if not "pyodide" in sys.modules: pause(0.0001)
    tplot = tplot + dtplot

plt.show()
