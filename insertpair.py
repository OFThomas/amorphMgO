#!/usr/bin/env/python
import numpy as np
#how many atoms in y and z
ny=6
nz=6
#total atoms
atoms= ny*nz*2

#lattice constant
lenunit = 4.212
delx=lenunit*0.5
dely=lenunit*0.5

#for lammps define 1 or 2 as atom type
mg=1
o=2

#Initial coords
xc1=0
xc2=0.5*lenunit

yc=0
zc=0

#for output in .xyz format
print atoms
print "0"

for i in range (0, ny):
	for j in range (0, nz):	
		#to alternate which column is written, Mg-O or O-Mg
		if ((i+j)%2 == 0):
			pair=1
		else:
			pair=2
		#swap elements for columns#
		if (pair==1):
			element1=mg
			element2=o		
		else:
			element1=o
			element2=mg
		#1st element is bottom of column
		#2nd element is on top of column
		print element1, xc1, yc+(delx*i), zc+(dely*j)
		print element2, xc2, yc+(delx*i), zc+(dely*j)
