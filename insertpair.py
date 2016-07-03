#!/bin/usr/env/python

import numpy as np
#atoms to add
#natoms=int(raw_input())

lenunit = 4.212
delx=0.8*lenunit
dely=0.8*lenunit

ypoint= 4*lenunit
zpoint= 2*lenunit


mg=1
o=2
xlower=0.0
xupper=4.212/float(2.0)
xc1=xlower
xc2=xupper

yc=6.1 #3delta x
zc=3.5 # 2delta y

yc=1.0*delx
zc=-0.5*dely

n=4
atom =1
for i in range (0, n):
	#if (i%2 == 0):
	#	xc1=xupper
	#	xc2=xlower
	#offsety=i+ypoint
	#offsetz=i+zpoint
	for j in range (0, n+1):
		#if ((i+j)%2==0):		
		print mg, xc1, yc+(delx*i), zc+(dely*j)
		print o, xc2, yc+(delx*i), zc+(dely*j)
		atom+=1
		xcold = xc1
		xc1 = xc2
		xc2 = xcold 
		#print i, j
	
#print mg, xc1, yc+(delx*3), zc+(dely*3)
#print o, xc2, yc+(delx*3), zc+(dely*3)
