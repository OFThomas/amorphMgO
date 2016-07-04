#!/bin/usr/env/python

lenunit = 4.212
delx=lenunit*0.5
dely=lenunit*0.5

mg=1
o=2

#Initial coords
xc1=0
xc2=0.5*lenunit
yc=0
zc=0
#how many atoms in y and z
ny=6
nz=6
atoms= ny*nz*2
print atoms
print "0"
counter =0

for i in range (0, ny):
	for j in range (0, nz):	
		if (counter%2 == 0):
			pair=1
		else:
			pair =2
		
		if (pair==1):
			element1=mg
			element2=o		
		else:
			element1=o
			element2=mg
		print element1, xc1, yc+(delx*i), zc+(dely*j)
		print element2, xc2, yc+(delx*i), zc+(dely*j)
		#swap elements for columns#
		counter +=1
	counter +=1
 
