import matplotlib.pyplot as plt

### Numerical simulation of object motion in 2D with gravity
## (SI units used throughout)
## Coordinates (y, z)

## parameters
m = 0.059 # kg: tennis ball's mass
g = 9.8 # N/kg: gravitational acceleration

## initial values
y = 0 # m: initial position
z = 2 # m
Py = 3 # N s: initial momentum
Pz = 0.75 # N s

## boundary conditions
Fy = 0 # N: momentum influx (constant)
Fz = 0 # N
Gy = 0 # N: momentum supply (constant)
Gz = -m * g

## duration of simulation
t = 0 # s: initial time
t1 = 2 # s: final time
dt = 0.01 # s: time step

## numerical time integration
while t < t1:
  vy = Py/m # constitutive relations
  vz = Pz/m

  Py = Py + (Fy + Gy) * dt # update momentum
  Pz = Pz + (Fz + Gz) * dt
  y = y + vy * dt # update position
  z = z + vz * dt

  t = t + dt # update time

## print final values
print(y)
print(z)
print(Py)
print(Pz)
plt.show()
