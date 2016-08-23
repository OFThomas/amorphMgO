#!/bin/bash

file=in.1d
#Generate test atom arrangement
python insertpair.py > testmc.xyz

Ny=50
Nz=50
num_atoms=5000

ydim=$(echo $Ny | awk '{print $1*2.106}')
zdim=$(echo $Nz | awk '{print $1*2.106}')

sed -i "/region box block/c\region box block 0.0 4.212 0.0 "$ydim" 0.0 "$zdim" units box" $file

lammps-daily < in.1d 
vmd dump.lammpstrj
