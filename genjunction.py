#!/usr/bin/env/python

import numpy as np

lenunit = 4.212
delx=0.5*lenunit
dely=0.4*lenunit

amindist=-30
bmindist=30

bmindist=-1
bmaxdist=20

n1=4.5
n2=4
n3=4

x=(float(n1**2.0)+(n2**2.0)-(n3**2.0))/(2.0*float(n1))
y =np.sqrt(float((n2**2.0))-x**2.0)

#basis vect

#Cry 1
a1x=1.0
a1y=0.0
b1x=0.5
b1y=-0.5

#Cry2
l=np.sqrt((x**2.0)+(y**2.0))

a2x=x/float(l)
a2=y/float(l)

oneoversqrttwo=1/float(np.sqrt(2.0))
b2x=oneoversqrttwo*a2x-oneoversqrttwo*a2y

b2y=+1.0d0*oneoversqrttwo*a2x+oneoversqrttwo*a2y
b2x=b2x*oneoversqrttwo
b2y=b2y*oneoversqrttwo

#Cry3

delx=x-n1
dely=y
l=np.sqrt((delx**2.0)+(dely**2.0))
	
a3x=delx/float(l)
a3y=dely/float(l)
	
oneoversqrttwo=1/float(np.sqrt(2.0))
b3x=oneoversqrttwo*a3x+oneoversqrttwo*a3y
b3y=-1.0d0*oneoversqrttwo*a3x+oneoversqrttwo*a3y
b3x=b3x*oneoversqrttwo
b3y=b3y*oneoversqrttwo

#DEFINE GRAIN BOUNDARIES
#GB crystal 1-2
gb1x=(a1x+a2x)*(-1.0)
gb1y=(a1y+a2y)*(-1.0)
	
#GB crystal 2-3
gb2x=(a2x+a3x)
gb2y=(a2y+a3y)

#GB crystal 3-1
gb3x=((-1.0)*a1x+a3x)*(-1.0)
gb3y=((-1.0)*a1y+a3y)*(-1.0)



