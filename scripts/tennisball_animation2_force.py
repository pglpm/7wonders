from matplotlib.pyplot import * ; from numpy import * ; from numpy.linalg import norm
from numpy import array as vector ; import matplotlib.pyplot as plt
### Numerical simulation of object motion with gravity
## Coordinates (t, x, z)

## Constants
ma = 0.06  # kg: tennis ball's mass-energy
mb = 0.06  # kg: 2nd tennis ball's mass-energy
g = 9.8    # N/kg: gravitational acceleration
k = 5      # N/m: elastic constant

## Initial conditions
t = 0                 # s: initial time
ra = vector([0, 5])   # m: initial position
va = vector([3, 7])   # m/s: initial velocity
Pa = ma * va          # N s: initial momentum
rb = vector([5, 5])   # m: initial position 2nd ball
vb = vector([-2, 7])  # m/s: initial velocity 2nd ball
Pb = mb * vb          # N s: initial momentum 2nd ball

## Boundary conditions
Ga = -ma * g * vector([0, 1])  # N: momentum supply
Gb = -mb * g * vector([0, 1])  # N: momentum supply 2nd ball

## Time-iteration parameters
t1 = 2       # s: final time
dt = 0.0001  # s: time step

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
clf
plot(ra[0], ra[1], 'o', color='#4477AA')
plot(rb[0], rb[1], 's', color='#EE6677')
xlabel('${\it x}$/m'); ylabel('${\it z}$/m')
axis('tight'); gca().set_aspect("equal", adjustable="box"); grid(True);

## Numerical time integration
while t < t1:

  ## constitutive relations
  va = Pa / ma
  vb = Pb / mb
  Fa = - k * (ra - rb)  # Hooke's law
  Fb = -Fa

  ## step forward in time with balance laws
  t = t + dt
  Pa = Pa + (Fa + Ga) * dt
  ra = ra + va * dt
  Pb = Pb + (Fb + Gb) * dt
  rb = rb + vb * dt

  ## plot
  if t > tplot:
    plot(ra[0], ra[1], 'o', color='#4477AA')
    plot(rb[0], rb[1], 's', color='#EE6677')
    xlabel('${\it x}$/m'); ylabel('${\it z}$/m')
    axis('tight'); gca().set_aspect("equal", adjustable="box"); grid(True);
    if not "pyodide" in sys.modules: pause(0.0001)
    tplot = tplot + dtplot
plt.show()
