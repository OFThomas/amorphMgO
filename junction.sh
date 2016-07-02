#!/bin/bash

num_atoms=3

gfortran triple.f -o triplegen.out 
./triplegen.out > test.xyz
emptyatoms=$(head -n 1 test.xyz)
python insertpair.py << EOF >> test.xyz
$num_atoms
EOF
totatoms="$(($emptyatoms+2*$num_atoms))" 
declare -i totatoms
sed -i "1 c\\"$totatoms" " test.xyz



