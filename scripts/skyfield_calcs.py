from skyfield.api import load
import numpy

# Create a timescale and ask the current time.
ts = load.timescale()
t = ts.utc(2025, 1, 1)

# Load the JPL ephemeris DE421 (covers 1900-2050).
planets = load('de421.bsp')
earth, moon = planets['earth'], planets['moon']

pose = earth.at(t)
posm = moon.at(t)
me = 5.972e24
mm = 7.346e22
cmv = (me*pose.xyz.m + mm*posm.xyz.m)/(me+mm)
cmd = cmv - pose.xyz.m
print('Earth x,y,z:', pose.xyz.m, 'm')
print('Moon x,y,z:', posm.xyz.m, 'm')
print('CM:', cmv)
print('CME:', cmd)
print('CM length:', numpy.linalg.norm(cmd))

# What's the position of Mars, viewed from Earth?
# astrometric = earth.at(t).observe(mars)
# ra, dec, distance = astrometric.radec()
# 
# print(ra)
# print(dec)
# print(distance)
