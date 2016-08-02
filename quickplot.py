#!/usr/bin/env/python

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as tick
from operator import itemgetter

#num_atoms=int(raw_input('enter total number of atoms: \n'))

#datafile=raw_input('enter data file name: \n')
datafile="energy.out"
datafile="288plot"
datafile="energy288.out"
energy, temp = np.genfromtxt(datafile, unpack=True)
#xp=np.linspace(0,len(energy), 100)
ax=plt.gca()
y_formatter=tick.ScalarFormatter(useOffset=False)
ax.yaxis.set_major_formatter(y_formatter) 
plt.plot( energy[22000:28800], 'ro-')
    
plt.ylabel('Energy, eV')
plt.xlabel('Monte-Carlo steps')
plt.title('Final energy of the crystal against number of steps')
#plt.plot((min(x), max(x)), (-1481.42658366852, -1481.42658366852), 'b-')
#save graph 
d_name = datafile + '.png'
plt.savefig(d_name, format='png')
