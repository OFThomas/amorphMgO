#!/bin/bash

num_atoms=3

gfortran triple.f -o triplegen.out 
./triplegen.out > test.xyz
emptyatoms=$(head -n 1 test.xyz)
#python insertpair.py  >> test.xyz
nlines=$(wc -l < ./test.xyz)
#totatoms="$(($emptyatoms+$nlines-$emptyatoms-2))"
#declare -i totatoms
#sed -i "1 c\\"$totatoms" " test.xyz

#python insertpair.py > test.xyz
# mpirun -np 6 lammps-daily < in.1d
lammps-daily < in.1d
vmd dump.lammpstrj

