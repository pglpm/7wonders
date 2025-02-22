#!/usr/bin/env python3

from matplotlib.pyplot import *
import matplotlib.pyplot as plt

### Numerical simulation for amount of substance in volume

## Initial conditions
t = 0 # s: initial time
N = 10 # mol: amount of substance

## Boundary conditions
J = 4 # mol/s: net influx, constant
A = 0 # net/s: net supply, constant

## Parameters for time loop
t1 = 2 # s: final time
dt = 0.01 # s: time step

## Numerical time integration
while t < t1:
    ## step forward in time with balance laws
    t = t + dt
    N = N + (J + A) * dt

## Print final value
print(N)
