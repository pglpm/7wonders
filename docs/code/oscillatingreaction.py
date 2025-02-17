#!/usr/bin/env python3

from matplotlib.pyplot import *
import matplotlib.pyplot as plt

### oscillatingreaction.m
## Numerical time integration of imaginary chemical reaction

## Constants
lambd = 6.283 # s^-1 # conversion rate

## Initial values
t = 0 # s # initial time
Nu = 2 # mol # volume content substance u
Nv = 3 # mol # volume content substance v

## Boundary conditions
Ju = 0 # mol/s # influx substance u
Jv = 0 # mol/s # influx substance v

## Parameters for time loop
t1 = 5 # s # duration of time integration
dt = 0.0001 # s # time step #@

## Plotting
tplot = 0 # time since last plot
dtplot = t1/360 # time interval between plots
clf()
plot(t, Nu, '.b')
xlim([0, t1])
xlabel('time t/s')
ylabel('amount N/mol')
grid(True)
plot(t, Nv, '.r') #@

## Numerical time integration
while t < t1:
  ## constitutive relations
  Au = -lambd * Nv
  Av = lambd * Nu

  ## balances: step forward in time
  Nu = Nu + (Ju + Au) * dt
  Nv = Nv + (Jv + Av) * dt
  t = t + dt #@

  ## plot
  if tplot < dtplot:
    tplot = tplot + dt
  else:
    plot(t, Nu, '.b')
    plot(t, Nv, '.r')
    plt.pause(0.001)
    tplot = 0

plt.show()
