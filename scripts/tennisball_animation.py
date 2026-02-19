from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Numerical simulation of object motion with gravity
## Coordinates (t, x, z)

## Constants
ma = 0.06  # kg: mass-energy tennis ball a
g = 9.8    # N/kg: gravitational acceleration

## Initial conditions
t = 0                # s: initial time
ra = vector([0, 5])  # m: initial position tennis ball a
va = vector([3, 7])  # m/s: initial velocity ball a
Pa = ma * va         # N s: initial momentum ball a

## Boundary conditions
Fa = vector([0, 0])            # N: momentum influx ball a
Ga = -ma * g * vector([0, 1])  # N: momentum supply ball a

## Time-iteration parameters
t1 = 2       # s: final time
dt = 0.0001  # s: time step

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
clf
plot(ra[0], ra[1], 'o', color='#4477AA')
xlabel('${\it x}$/m'); ylabel('${\it z}$/m')
axis('tight'); gca().set_aspect("equal", adjustable="box"); grid(True);

## Numerical time integration
while t < t1:

  ## constitutive relations
  va = Pa / ma

  ## step forward in time with balance laws
  t = t + dt
  Pa = Pa + (Fa + Ga) * dt
  ra = ra + va * dt

  ## plot
  if t > tplot:
    ## clf() # comment for matplotlib.online
    plot(ra[0], ra[1], 'o', color='#4477AA')
    xlabel('${\it x}$/m'); ylabel('${\it z}$/m')
    axis('tight'); gca().set_aspect("equal", adjustable="box"); grid(True);
    pause(0.0001) # comment for matplotlib.online
    tplot = tplot + dtplot
plt.show()
