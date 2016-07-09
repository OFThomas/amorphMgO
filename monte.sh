#!/bin/bash

file=in.1dmc
#Generate test atom arrangement
python insertpair.py > testmc.xyz
#---- 0 to run lammps
#---- 1 to skip to plotting
skip=0

disordermoves=100
disinc=100
end_dis=1000

totsteps=1000
stepsinc=500
end_steps=5000

temp=0.025
end_temp=0.5
tinc=0.1

#Fitting params
num_atoms=72
filetoplot=disorderplot.txt
DOF=2
system=0

if [ $skip -eq 0 ]; then
rm ./disorderplot.txt

while [ 0 -lt $(echo $disordermoves $end_dis | awk '{if ($1<=$2) print 1; else print 0;}') ]
do 
vary=$disordermoves
#vary=$totsteps

sed -i "/variable disorder equal/c\variable disorder equal "$disordermoves"" $file	
sed -i "/variable iter loop/c\variable iter loop "$totsteps"" $file
sed -i "/variable T equal/c\variable T equal "$temp"" $file
lammps-daily < in.1dmc >temp.txt
tail -n 14 temp.txt >> ./data/output.txt
#rm ./temp.txt

search=$(grep "final energy" ./temp.txt)
energy=$(echo $search | awk '{print $4}')
echo "Disorder moves: "$vary "Temp: " $temp "Energy: " $energy
#echo "total moves moves: "$vary "Temp: " $temp "Energy: " $energy
echo $vary $energy >> disorderplot.txt

#mv output.txt ./data/output.txt
#if [ $skip -eq 1 ] ; then
#	vmd dumpmc.lammpstrj
#else
#	echo "skipped"
#fi
#more disorderplot.txt

#temp=$(echo $temp $tinc | awk '{print $1+$2}')
disordermoves=$(echo $disordermoves $disinc | awk '{print $1+$2}')
#totsteps=$(echo $totsteps $stepsinc | awk '{print $1+$2}')
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
wait
