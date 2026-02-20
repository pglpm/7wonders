from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Simulation of double pendulum in 2D
## Coordinates (t, y, z)

## Constants
ma = 1      # kg: mass of object a
mb = 1      # kg: mass of object b
g = 9.81    # N/kg: gravitational acceleration
ln = 1      # m: natural length
k = 100000  # N/m: spring constant

## Initial conditions
t = 0                                       # s: initial time
anglea = pi/2                               # rad: initial angle from vertical a
ra = ln * vector([sin(anglea), -cos(anglea)])       # m: initial position of object a
angleb = 0                                  # rad: initial angle from vertical b
rb = ra + ln * vector([sin(angleb), -cos(angleb)])  # m: initial position of object b
va = vector([0, 0])                                 # m/s: initial velocity of object a
vb = vector([0, 0])                                 # m/s: initial velocity of object b

## Boundary conditions
Ga = -ma * g * vector([0, 1])  # N: gravity supply on object a
Gb = -mb * g * vector([0, 1])  # N: gravity supply on object b

## Parameters for time loop
t1 = 10       # s: final time
dt = 0.00001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
figure
plot(0, 0, 'sk')
xlim([-2*ln, 2*ln]); ylim([-2*ln,0])
grid(True); gca().set_aspect("equal", adjustable="box")
plot([0, ra[0]], [0, ra[1]], '-b')
plot(ra[0], ra[1], 'ob')
plot([ra[0], rb[0]], [ra[1], rb[1]], '-r')
plot(rb[0], rb[1], 'or')
xlabel('${\it y}$/m'); ylabel('${\it z}$/m') #@

## State: ra, rb, va, vb
## Numerical time integration
while t < t1:
  ## constitutive relations
  Pa = ma * va
  Pb = mb * vb
  la = norm(ra)       # calculation of present length
  lb = norm(rb - ra)  # calculation of present length
  F0a = -k * (la - ln) * ra / la
  Fb = -k * (lb - ln) * (rb - ra)/lb
  Fba = -Fb           # balance of momentum for non-Hookean material
  Fa = F0a + Fba

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
    if not "pyodide" in sys.modules: clf()
    plot(0, 0, 'sk')
    xlim([-2*ln, 2*ln]); ylim([-2*ln,0])
    grid(True); gca().set_aspect("equal", adjustable="box")
    plot([0, ra[0]], [0, ra[1]], '-b')
    plot(ra[0], ra[1], 'ob')
    plot([ra[0], rb[0]], [ra[1], rb[1]], '-r')
    plot(rb[0], rb[1], 'or')
    if not "pyodide" in sys.modules: pause(0.0001)
    tplot = tplot + dtplot

plt.show()
