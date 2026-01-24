from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Time integration of dimerization-dissociation reaction
## Coordinates (t)

## Constants
R = 8.31446261815324  # J/(K*mol): molar gas constant
A1 = 1.88e5           # m**3/(mol*s): pre-expon. 2NO2->N2O4
E1 = -2.23e3          # J/mol: activation energy 2NO2->N2O4
A2 = 4.30e15          # 1/s: pre-expon. N2O4->2NO2
E2 = 5.32e4           # J/mol: activation energy N2O4->2NO2

## Initial conditions
t = 0          # s: time
N_NO2 = 0.00   # mol: amount NO2
N_N2O4 = 0.04  # mol: amount N2O4

## Boundary conditions
T = 330     # K: temperature
V = 0.001   # m**3: volume
J_NO2 = 0   # mol/s: influx of NO2
J_N2O4 = 0  # mol/s: influx of N2O4

## Time-iteration parameters

## uncomment these for longer simulation
t1 = 0.01  # s: final time
dt = 1e-8  # s: time step

## uncomment these for shorter simulation
#t1 = 2e-7   # s: final time
#dt = 1e-10  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
figure
plot(t, N_NO2, 'o', color = '#EE6677')
plot(t, N_N2O4, 'o', color = '#CCBB44')
legend(['NO_2', 'N_2O_4'])
xlim([0, t1])
xlabel('${\it t}$/s'); ylabel('${\it N}$/mol')
grid(True) #@

## Numerical time integration
while t < t1:
  ## constitutive relations
  ## rates of conversion
  xidot1 = A1 * exp(-E1 / (R * T)) * N_NO2**2 / V
  xidot2 = A2 * exp(-E2 / (R * T)) * N_N2O4
  ## rates of formation (supplies)
  R_NO2 = -2 * xidot1 + 2 * xidot2
  R_N2O4 = xidot1 - xidot2

  ## step forward in time with balance laws
  t = t + dt
  N_NO2 = N_NO2 + (J_NO2 + R_NO2) * dt
  N_N2O4 = N_N2O4 + (J_N2O4 + R_N2O4) * dt #@

  ## plot
  if t > tplot:
    plot(t, N_NO2, 'o', color = '#EE6677')
    plot(t, N_N2O4, 'o', color = '#CCBB44')
    # pause(0.0001) # comment for matplotlib.online
    tplot = tplot + dtplot

plt.show()
