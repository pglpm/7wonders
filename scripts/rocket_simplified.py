from matplotlib.pyplot import *
from numpy import *
from numpy.linalg import norm
from numpy import array as vector
import matplotlib.pyplot as plt
### Numerical simulation of rocket propulsion
## Coordinates (t, z)

## Constants
m = 7.9e5    # kg: rocket mass without fuel
rho = 0.22   # kg/mol: fuel molar mass
delta = 0.5  # mol/m**3: fuel molar density
A = 50       # m**2: nozzle area
g = 9.8      # N/kg: free-fall acceleration

## Initial conditions. State: (z, v, Nb)
t = 0       # s: initial time
z = 0       # m: altitude of control volume
v = 0       # m/s: velocity of control volume
Nb = 9.8e6  # mol: amount of fuel

## Boundary conditions
J = -6e4          # mol/s: matter influx at nozzle
patm = 1e5        # N/m**2: atmospheric pressure
p = 5e4           # N/m**2: pressure at nozzle
Fatm = -A * patm  # N: force on rocket surface
Fstress = A * p     # N: stress tensor at nozzle

## Time-iteration parameters
t1 = 150     # s: final time
dt = 0.0001  # s: time step #@

## Plotting
dtplot = t1/360  # time interval between plots
tplot = dtplot   # time for next plot
figure
subplot(2, 1, 1); plot(t, z, 'o', color='#4477AA')
xlabel('time ${\it t}$/s'); ylabel('${\it z}$/m')
xlim([0, t1]); grid(True); 
subplot(2, 1, 2); plot(t, v, '^', color='#EE6677')
xlabel('${\it t}$/s'); ylabel('${\it v}$ / (m/s)')
xlim([0, t1]); grid(True);  #@

## Numerical time integration
while t < t1 and Nb > 0:
  ## constitutive relations
  P = (m + rho * Nb) * v
  vb = v + J / (A * delta) # needed to calculate F
  F = Fatm + Fstress + J * rho * vb
  G = -(m + rho * Nb) * g

  ## step forward in time with balance laws
  t = t + dt
  Nb = Nb + J * dt
  P = P + (F + G) * dt
  z = z + v * dt

  ## constitutive relations: calculate state
  v = P / (m + rho * Nb) #@

  ## plot
  if t > tplot:
    subplot(2, 1, 1); plot(t, z, 'o', color='#4477AA')
    subplot(2, 1, 2); plot(t, v, '^', color='#EE6677')
    if not "pyodide" in sys.modules: pause(0.0001)
    tplot = tplot + dtplot

plt.show()
