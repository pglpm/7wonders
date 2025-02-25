### Simulation of two bodies connected by Hookean material in 2D
## Coordinates (y, z)
from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt

## Constants
ma = 2	  # kg: mass of object a
mb = 2	  # kg: mass of object b
g = 9.81  # N/kg: gravitational acceleration
ln = 1	  # m: natural length
k = 5	  # N/m: spring constant

## Initial conditions
t = 0                 # s: initial time
ra = vector([-3, 0])  # m: initial position of object a
rb = vector([3, 0])   # m: initial position of object b
va = vector([0, 10])  # m/s: initial velocity of object a
vb = vector([0, 0])   # m/s: initial velocity of object b

## Boundary conditions
Ga = -ma * g * vector([0, 1])  # N: gravity supply on object a
Gb = -mb * g * vector([0, 1])  # N: gravity supply on object b

## Parameters for time loop
t1 = 5	    # s: final time
dt = 0.001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot	 # time for next plot
clf
plot(ra[0], ra[1], 'sb')
grid(True)
plot(rb[0], rb[1], 'or')
xlabel('position y/m'); ylabel('position z/m') #@

## State: ra, rb, va, vb
## Numerical time integration
while t < t1:
  ## constitutive relations
  Pa = ma * va
  Pb = ma * vb
  l = norm(ra - rb) # calculation of present length
  Fxa = -k * (l - ln) * (ra - rb)/l
  Fxb = -Fxa # balance of momentum for Hookean material

  ## balances
  t = t + dt
  Pa = Pa + (Fxa + Ga) * dt
  Pb = Pb + (Fxb + Gb) * dt
  ra = ra + va * dt
  rb = rb + vb * dt

  ## constitutive relations
  va = Pa / ma
  vb = Pb / mb #@

  ## plot
  if t > tplot:
    plot(ra[0], ra[1], 'sb')
    plot(rb[0], rb[1], 'or')
    tplot = tplot + dtplot

plt.show()
