from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Simulation of two bodies connected by Hookean material in 2D
## Coordinates (t, z)

## Constants
ma = 5	 # kg: mass object a
g = 9.8  # N/kg: gravitational acceleration
k = 25	 # N/m: spring constant

## Initial conditions
t = 0	   # s: initial time
ra = -1.8  # m: initial position object a
va = 0     # m/s: initial velocity object a

## Boundary conditions
Ga = -ma * g  # N: gravity supply object a

## Parameters for time loop
t1 = 10	     # s: final time
dt = 0.0001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot	  # time for next plot
clf
plot(t, ra, 'o', color='#4477AA')
xlabel('${\it t}$/s'); ylabel('${\it r_a}$/m')
axis('tight'); xlim([0, t1]); grid(True) #@

## Numerical time integration
while t < t1:
  ## constitutive relations
  Pa = ma * va
  Fa = -k * ra

  ## balance laws
  t = t + dt
  Pa = Pa + (Fa + Ga) * dt
  ra = ra + va * dt

  ## constitutive relations
  va = Pa / ma #@

  ## plot
  if t > tplot:
    plot(t, ra, 'o', color='#4477AA')
    if not "pyodide" in sys.modules: pause(0.0001)
    tplot = tplot + dtplot

plt.show()
