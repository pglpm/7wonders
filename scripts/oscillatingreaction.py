from matplotlib.pyplot import *
import matplotlib.pyplot as plt
### Numerical time integration of imaginary chemical reaction

## Constants
lambd = 6.283 # s^-1: conversion rate

## Initial conditions
t = 0 # s: initial time
Na = 2 # mol: volume content substance a
Nb = 3 # mol: volume content substance b

## Boundary conditions
Ja = 0 # mol/s: influx substance a
Jb = 0 # mol/s: influx substance b

## Time-iteration parameters
t1 = 5 # s: duration of time integration
dt = 0.0001 # s: time step

## Plotting
dtplot = t1/360; # time interval between plots
tplot = dtplot; # time for next plot
figure
plot(t, Na, 'oy')
xlim([0, t1])
xlabel('time ${\it t}$/s'); ylabel('amount ${\it N}$/mol')
grid(True)
plot(t, Nb, 'vr')

## Numerical time integration
while t < t1:
  ## constitutive relations
  Ra = -lambd * Nb
  Rb = lambd * Na
  
  ## step forward in time with balance laws
  t = t + dt
  Na = Na + (Ja + Ra) * dt
  Nb = Nb + (Jb + Rb) * dt
  
  ## plot
  if t > tplot:
    plot(t, Na, 'ob')
    plot(t, Nb, 'vr')
    tplot = tplot + dtplot

plt.show()
