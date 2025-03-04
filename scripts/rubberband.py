### Simulation of two bodies connected by non-Hookean material in 2D
## Coordinates (t, y, z)
from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt

## Constants
ma = 2	   # kg: mass of object a
mb = 5000  # kg: mass of object b
g = 9.81   # N/kg: gravitational acceleration
ln = 5	   # m: natural length
k = 5	   # N/m: spring constant

## Initial conditions
t = 0                 # s: initial time
ra = vector([-3, 3])  # m: initial position of object a
rb = vector([0, 0])   # m: initial position of object b
va = vector([0, 0])   # m/s: initial velocity of object a
vb = vector([0, 0])   # m/s: initial velocity of object b

## Boundary conditions
Ga = -ma * g * vector([0, 1])      # N: gravity supply on object a
Gb = -mb * g * vector([0, 1]) * 0  # N: gravity supply on object b

## Parameters for time loop
t1 = 10	     # s: final time
dt = 0.0001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot	 # time for next plot
figure
plot(ra[0], ra[1], 'ob')
grid(True)
plot(rb[0], rb[1], 'sr')
xlabel('${\it y}$/m'); ylabel('${\it z}$/m') #@

## State: ra, rb, va, vb
## Numerical time integration
while t < t1:
  ## constitutive relations
  Pa = ma * va
  Pb = mb * vb
  l = norm(ra - rb) # calculation of present length
  if l < ln:
    Fa = vector([0, 0])
  else:
    Fa = -k * (l - ln) * (ra - rb)/l
  Fb = -Fa # balance of momentum for non-Hookean material

  ## balances
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
    plot(ra[0], ra[1], 'ob')
    plot(rb[0], rb[1], 'sr')
    tplot = tplot + dtplot

plt.show()
