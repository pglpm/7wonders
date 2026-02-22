### Simulation of two bodies connected by Hookean material in 2D
## Coordinates (t, x, z)
from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt

## Constants
ma = 2	 # kg: mass object a
mb = 3	 # kg: mass object b
g = 9.8  # N/kg: gravitational acceleration
k = 5	 # N/m: spring constant

## Initial conditions
t = 0                 # s: initial time
ra = vector([-3, 0])  # m: initial position object a
rb = vector([3, 0])   # m: initial position object b
va = vector([0, 10])  # m/s: initial velocity object a
vb = vector([0, 0])   # m/s: initial velocity object b

## Boundary conditions
Ga = -ma * g * vector([0, 1])  # N: gravity supply object a
Gb = -mb * g * vector([0, 1])  # N: gravity supply object b

## Parameters for time loop
t1 = 5	     # s: final time
dt = 0.0001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot	 # time for next plot
figure
plot(ra[0], ra[1], 'o', color='#4477AA')
grid(True)
plot(rb[0], rb[1], 's', color='#EE6677')
xlabel('${\it x}$/m'); ylabel('${\it z}$/m') #@

## State: ra, rb, va, vb
## Numerical time integration
while t < t1:
  ## constitutive relations
  Pa = ma * va
  Pb = mb * vb
  Fa = -k * (ra - rb)/l
  Fb = -Fa # balance of momentum for Hookean material

  ## balance laws
  t = t + dt
  Pa = Pa + (Fa + Ga) * dt
  Pb = Pb + (Fb + Gb) * dt
  ra = ra + va * dt
  rb = rb + vb * dt

  ## constitutive relations
  va = Pa / ma
  vb = Pb / mb #@

  ## plot
  if t > tplot:
    plot(ra[0], ra[1], 'o', color='#4477AA')
    plot(rb[0], rb[1], 's', color='#EE6677')
    tplot = tplot + dtplot

plt.show()
