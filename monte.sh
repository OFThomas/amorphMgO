#!/bin/bash

file=in.1dmc
#Generate test atom arrangement
python insertpair.py > testmc.xyz
#---- 0 to run lammps
#---- 1 to skip to plotting
skip=0

#Fitting params
num_atoms=72
filetoplot=disorderplot.txt
DOF=9
system=0
i=0
te=0

#---------------------------------------------------------------------------------------
disordermoves=500
disinc=100
end_dis=1000

temp=0.025
end_temp=1
tinc=0.1
#------------------------------------------------------------------------------------

if [ $skip -eq 0 ]; then
rm ./disorderplot.txt

while [ 0 -lt $(echo $temp $end_temp | awk '{if ($1<=$2) print 1; else print 0;}') ]
do 
#--------------------------------------------------------------------------------
totsteps=1500
stepsinc=500
end_steps=6000
#--------------------------------------------------------------------------------
while [ 0 -lt $(echo $totsteps $end_steps | awk '{if ($1<=$2) print 1; else print 0;}') ]
do 
i=$((i+1))
te=$(echo $temp | awk '{print $1*1000}')
#vary=$disordermoves
vary=$totsteps

sed -i "/variable disorder equal/c\variable disorder equal "$disordermoves"" $file	
sed -i "/variable iter loop/c\variable iter loop "$totsteps"" $file
sed -i "/variable T equal/c\variable T equal "$temp"" $file
sed -i "/dump 1 all custom 1 dumpmc/c\dump 1 all custom 1 dumpmc"$temp".lammpstrj id type xs ys zs " $file
lammps-daily < in.1dmc >temp.txt
tail -n 14 temp.txt >> ./data/outputT$te.txt
#rm ./temp.txt

search=$(grep "final energy" ./temp.txt)
energy=$(echo $search | awk '{print $4}')
#echo "Disorder moves: "$vary "Temp: " $temp "Energy: " $energy
echo "total moves: "$vary "Temp: " $temp "Energy: " $energy
echo $vary $energy >> disorderplot.txt

#mv output.txt ./data/output.txt
#if [ $skip -eq 1 ] ; then
#	vmd dumpmc.lammpstrj
#else
#	echo "skipped"
#fi
#more disorderplot.txt

#disordermoves=$(echo $disordermoves $disinc | awk '{print $1+$2}')
totsteps=$(echo $totsteps $stepsinc | awk '{print $1+$2}')
done

temp=$(echo $temp $tinc | awk '{print $1+$2}')

done

else
echo "Skipping to plotting"
fi
python2 plot.py << EOF
$num_atoms
$filetoplot
$DOF
$system
EOF

display $filetoplot.png &	#Show percentage to total energy
