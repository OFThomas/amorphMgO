#!/bin/bash
#skip=$1
python insertpair.py > testmc.xyz
#mpirun -np 6 lammps-daily < in.1dmc
lammps-daily < in.1dmc
#if [ $skip -eq 1 ] ; then
#	vmd dumpmc.lammpstrj
#else
	echo "skipped"
#fi
