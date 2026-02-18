from matplotlib.pyplot import * ; from numpy import * ; from numpy.linalg import norm
from numpy import array as vector ; import matplotlib.pyplot as plt
### Numerical simulation of object motion with gravity
## Coordinates (t, x, z)

## Constants
m = 0.06   # kg: tennis ball's mass-energy
m2 = 0.06  # kg: 2nd tennis ball's mass-energy
g = 9.8    # N/kg: gravitational acceleration
k = 5      # N/m: elastic constant

## Initial conditions
t = 0                 # s: initial time
r = vector([0, 5])    # m: initial position
v = vector([3, 7])    # m/s: initial velocity
P = m * v             # N s: initial momentum
r2 = vector([5, 5])   # m: initial position 2nd ball
v2 = vector([-2, 7])  # m/s: initial velocity 2nd ball
P2 = m2 * v2          # N s: initial momentum 2nd ball

## Boundary conditions
G = -m * g * vector([0, 1])    # N: momentum supply
G2 = -m2 * g * vector([0, 1])  # N: momentum supply 2nd ball

## Time-iteration parameters
t1 = 2       # s: final time
dt = 0.0001  # s: time step

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
clf
plot(r[0], r[1], 'o', color='#4477AA')
plot(r2[0], r2[1], 's', color='#EE6677')
xlabel('${\it x}$/m'); ylabel('${\it z}$/m')
axis('tight'); gca().set_aspect("equal", adjustable="box"); grid(True);

## Numerical time integration
while t < t1:

  ## constitutive relations
  v = P / m
  v2 = P2 / m2
  F = - k * (r - r2)  # Hooke's law
  F2 = -F             # symmetry of flux

  ## step forward in time with balance laws
  t = t + dt
  P = P + (F + G) * dt
  r = r + v * dt
  P2 = P2 + (F2 + G2) * dt
  r2 = r2 + v2 * dt

  ## plot
  if t > tplot:
    plot(r[0], r[1], 'o', color='#4477AA')
    plot(r2[0], r2[1], 's', color='#EE6677')
    xlabel('${\it x}$/m'); ylabel('${\it z}$/m')
    axis('tight'); gca().set_aspect("equal", adjustable="box"); grid(True);
    ## pause(0.0001) # comment for matplotlib.online
    tplot = tplot + dtplot
plt.show()
