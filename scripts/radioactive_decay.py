from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Time integration of radioactive decay

## Constants
lambd = 0.000122  # 1/yr: decay constant for C14

## Initial conditions
t = 0	   # s: initial time
N = 1e-12  # mol: initial amount of C14

## Boundary conditions
J = 0  # mol/s: matter influx of C14

## Parameters for time loop
t1 = 20000  # yr: final time
dt = 0.1    # yr: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot	  # time for next plot
figure
plot(t, N, '.', 'color', '#4477AA')
xlabel('${\it t}$/s'); ylabel('${\it N}$/mol')
grid(True);  #@

## Numerical time integration
while t < t1:
  ## constitutive relations
  R = -lambd * N

  ## step forward in time with balance law
  t = t + dt
  N = N + (J + R) * dt #@

  ## plot
  if t > tplot:
    plot(t, N, '.', 'color', '#4477AA')
    # pause(0.0001) # comment for matplotlib.online
    tplot = tplot + dtplot

plt.show()
