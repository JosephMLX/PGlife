#!/usr/bin/python3
import sys

u = int(sys.argv[1])
v = int(sys.argv[2])
while v:
	t = u
	u = v
	v = t % v
if u < 0:
	u = -u
print("The gcd of", sys.argv[1], "and", sys.argv[2], "is", u);
