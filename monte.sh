#!/bin/bash

python insertpair.py > testmc.xyz
#mpirun -np 6 lammps-daily < in.1dmc
lammps-daily < in.1dmc
vmd dumpmc.lammpstrj


