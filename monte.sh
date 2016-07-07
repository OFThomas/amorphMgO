#!/bin/bash
#skip=$1
python insertpair.py > testmc.xyz
#mpirun -np 6 lammps-daily < in.1dmc
lammps-daily < in.1dmc >temp.txt
tail -n 14 temp.txt >> ./data/output.txt
#rm ./temp.txt
grep "final energy" ./data/output.txt
#mv output.txt ./data/output.txt
#if [ $skip -eq 1 ] ; then
#	vmd dumpmc.lammpstrj
#else
	echo "skipped"
#fi
