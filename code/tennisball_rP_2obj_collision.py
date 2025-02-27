### Numerical simulation of object motion with gravity
## Coordinates (t, x, y, z)
from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt

## Constants
ma = 0.06 # kg: mass-energy object a
mb = 0.06 # kg: mass-energy object b
g = 9.8 # N/kg: gravitational acceleration
k = 10 # elastic constant
d = 0.07 # m: distance between centres of objects

## Initial conditions
t = 0 # s: initial time
ra = vector([0, 0, 10]) # m: initial position vector a
rb = vector([0, 0, 5]) # m: initial position vector b
Pa = vector([0, 0, -0.5]) # N s: initial momentum vector a
Pb = vector([0, 0, 0.5]) # N s: initial momentum vector b

## Boundary conditions
Ga = -ma * g * vector([0, 0, 1]) # N: momentum supply object a
Gb = -mb * g * vector([0, 0, 1]) # N: momentum supply object b

## Time-iteration parameters
t1 = 2 # s: final time
dt = 0.00001 # s: time step #@

## Plotting
dtplot = t1/360 # time interval between plots
tplot = dtplot # time for next plot
figure
subplot(2, 1, 1); plot(t, ra[2], '.b')
xlim([0, t1])
xlabel('time t/s'); ylabel('z_a/m')
grid(True); 
subplot(2, 1, 2); plot(t, rb[2], '.r')
xlim([0, t1])
xlabel('time t/s'); ylabel('z_b/m')
grid(True);  #@

## Numerical time integration
while t < t1:
  ## constitutive relations
  va = Pa / ma
  vb = Pb / mb
  ## const. relation for Fa
  if norm(ra - rb) > d:
    Fa = vector([0, 0, 0])
  else:
    Fa = k * (ra - rb) / norm(ra - rb)**2
  Fb = -Fa # principle of symmetry of flux

  ## step forward in time with balance laws
  t = t + dt
  Pa = Pa + (Fa + Ga) * dt
  ra = ra + va * dt
  Pb = Pb + (Fb + Gb) * dt
  rb = rb + vb * dt #@

  ## plot
  if t > tplot:
    subplot(2, 1, 1); plot(t, ra[2], '.b')
    subplot(2, 1, 2); plot(t, rb[2], '.r')
    tplot = tplot + dtplot

plt.show()
