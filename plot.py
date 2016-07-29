#!/usr/bin/env/python

import numpy as np
import matplotlib.pyplot as plt
from operator import itemgetter

num_atoms=int(raw_input('enter total number of atoms: \n'))

datafile=raw_input('enter data file name: \n')
x, y = np.genfromtxt(datafile, unpack=True)

#order of fit
n=int(raw_input('enter degrees of freedom for fit: \n'))
case=int(raw_input('0 vary steps, 1 vary Temperature: \n'))

# get the energy per atom (all have the same total number of atoms)
#y /= num_atoms

#Calculate best fit order n 
#p[0] = ax^2 ,p[1] = bx, p[2] = c
p = np.polyfit(x,y,n)

#------------------------- Convex hull approach -----------------------
#linear fit 
#line=np.polyfit(x,y,1)

#set the gradient of the linear fit to the gradient of the quadratic fit
#Without this the x=1 point does not reach zero but ends up at negative energies
#line[1]=p[2]
#----------------------------------------------------------------------------

#rewrite fit as a function
fit =np.poly1d(p)
#generate smooth points to plot the fit
xp=np.linspace(min(x),max(x), 100)

#PLOT ENERGY DATA
#plt.plot(x, y/num_atoms, 'ro', xp, fit(xp), 'r-')

########## Then change title and axis respectively #################

#CASE 0 FOR ENERGIES with steps
if(case==0):
    #PLOT ENERGY DATA
    plt.plot(x, y, 'ro', xp, fit(xp), 'r-')
    
    plt.ylabel('Energy, eV')
    plt.xlabel('Monte-Carlo steps')
    plt.title('Final energy of the crystal against number of steps')
    #plt.plot((min(x), max(x)), (-1481.42658366852, -1481.42658366852), 'b-')
    #save graph 
    d_name = datafile + '.png'
    plt.savefig(d_name, format='png')

#CASE 1 FOR ENERGY with temperature
elif (case==1):
    #PLOT ENERGY DATA
    plt.plot(x, y, 'ro', xp, fit(xp), 'r-')

    plt.ylabel('Percentage of Accepted/Total moves')
    plt.xlabel('Move number')
    plt.title('Variation of Accepted/Total moves with move number')
    #save graph 
    d_name = datafile + '.png'
    plt.savefig(d_name, format='png')
#    plt.clf()

#Not needed yet, can use for lowest formation energy calc
"""
    #plot fixed energy of formation
    form_en=fixy(x, fit(x), line, int(n))

    np.savetxt('formation_energies.dat',np.column_stack((x,form_en)))

    # print lowest formation energy
    print 'lowest formation energy', min(form_en), 'eV'

    # print corresponding total energy
    print 'lowest total energy', min(y*num_atoms), 'eV'
    
    # print percentage for minimum formation energy
    print 'lowest formation energy percentage', x[min(enumerate(form_en), key=itemgetter(1))[0]], '%'

    plt.plot(x, form_en, 'ro-')

    plt.ylabel('Energy, eV')
    plt.xlabel('Percentage composition of Mg/(Mg+Ca)')
    plt.title('Formation Energy for Composition of Mg/(Mg+Ca)')
    #save graph
    plt.savefig('eform.png',format='png')
"""
