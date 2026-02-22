from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Simulation of two bodies connected by Hookean material in 2D
## Coordinates (t, z)

## Constants
m = 5	 # kg: mass object a
g = 9.8  # N/kg: gravitational acceleration
k = 25	 # N/m: spring constant

## Initial conditions
t = 0	   # s: time
z = -1.8  # m: position object a
v = 0     # m/s: velocity object a

## Boundary conditions
G = -m * g  # N: gravity supply object a

## Parameters for time loop
t1 = 10	     # s: final time
dt = 0.0001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot	  # time for next plot
clf
plot(t, z, 'o', color='#4477AA')
xlabel('${\it t}$/s'); ylabel('${\it z}$/m')
xlim([0, t1]); grid(True) #@

## Numerical time integration
while t < t1:
  ## constitutive relations
  P = m * v
  F = -k * z

  ## balance laws
  t = t + dt
  P = P + (F + G) * dt
  z = z + v * dt

  ## constitutive relations
  v = P / m #@

  ## plot
  if t > tplot:
    plot(t, z, 'o', color='#4477AA')
    if not "pyodide" in sys.modules: pause(0.0001)
    tplot = tplot + dtplot

plt.show()
