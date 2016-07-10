#!/bin/bash

num_atoms=72

gfortran triple.f -o triplegen.out 
./triplegen.out > test.xyz
emptyatoms=$(head -n 1 test.xyz)
python insertpair.py  >> test.xyz
nlines=$(wc -l < ./test.xyz)
echo $emptyatoms
echo $nlines
totatoms="$(($emptyatoms+$nlines-$emptyatoms-2))"
echo $totatoms
declare -i totatoms
sed -i "1 c\\"$totatoms" " test.xyz

# mpirun -np 6 lammps-daily < in.1d
#lammps-daily < in.1d
#vmd dump.lammpstrj
vmd test.xyz
