#!/bin/bash
gfortran -o crystal crystal.f90
gfortran -o md3 md3.f90
# echo compiled

#Production timesteps
n_timestep="500000"

n_ts_equib="10000"
timestep="0.004"
density="0.7"
crystal="initial_coords_256"

temp="1.00"
end_temp="2.5"
tincr="0.1"

# write out mean values for each simulation at different T*#
dest_mean=/home/oliver/Desktop/molsim/meanvals.dat
echo "Timesteps" $n_timestep >> "$dest_mean"
echo "Temperature, Kinetic, Potential, Total Energy, Pressure" >> "$dest_mean"
echo >> "$dest_mean"

#Loop through different T*
while [ 0 -lt $(echo $temp $end_temp | awk '{if ($1<=$2) print 1; else print 0;}') ]
do
echo $temp

tname=$(echo $temp | awk '{print $1*100}') 
equil="equil_$tname" && prod="prod_$tname"

#If equilibrium.out file already exists, skip to production 
if ! [ -s $equil.out ]; then
  echo "Not there"

#########Generate lattice arrangment of atoms#######
rm $crystal
./crystal << EOF
1
1.5496
4
4
4
0.1
$crystal
EOF

###################Create Equib file###############
cat <<EOF >$equil.in
Equilibrate 256 particles, density=$density, T*=$temp
$crystal
$equil.out
$n_ts_equib
$timestep
$density
$temp
.1
EOF

###############Setup Equilibrium########################
time ./md3 <$equil.in >$equil.tup 
echo Equil done

#Equilibrium file already exists, go to production stage
else
  echo "It is there, skip to production"
fi

###############Create Production file#####################
cat <<EOF >$prod.in
Production run, 256 particles, density=$density, T*=$temp
$equil.out
$prod.out
$n_timestep
$timestep
$density
-1
.1
EOF
  
####################Simulate production stage############
time ./md3 <$prod.in >$prod.tup 
echo Prod done

####################end of simulations################

#Grab last line which has the average values
string=$(tail -1 $prod.tup)
averages=$(echo $string | awk '{print $3,$4,$5,$6,$7}')

#echo "Temperature, Kinetic, Potential, Total Energy, Pressure"
echo $temp $averages >> "$dest_mean"
echo "written to meanvals.dat"

#incriment Temp
temp=$(echo $temp $tincr | awk '{print $1+$2}')

#remove all generated .in files to clean up directory
for file in  ./*.in
do
rm $file
done

done
