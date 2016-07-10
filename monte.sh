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
tcount=0
#---------------------------------------------------------------------------------------
disordermoves=500
disinc=100
end_dis=1000

temp=1.025
end_temp=1.225
tinc=0.2
#------------------------------------------------------------------------------------

if [ $skip -eq 0 ]; then
rm ./disorderplot.txt

while [ 0 -lt $(echo $temp $end_temp | awk '{if ($1<=$2) print 1; else print 0;}') ]
do 
tcount=$((tcount+1))
#--------------------------------------------------------------------------------
totsteps=6000
stepsinc=500
end_steps=6001
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

#----------------- Energy plot every step--------------
rm ./energyplot$i+$tcount.txt
for j in $(eval echo "{501..$totsteps}")
do
if [ $j -lt 1000 ]; then 
	searchenergy=$(grep "^     $j" ./temp.txt)
else
	searchenergy=$(grep "^    $j" ./temp.txt)
fi
stepenergy=$(echo $searchenergy | awk '{print $5}')
echo $j $stepenergy >> energyplot$i+$te.txt
done 
#-----------------------------------------------------------------

#disordermoves=$(echo $disordermoves $disinc | awk '{print $1+$2}')
totsteps=$(echo $totsteps $stepsinc | awk '{print $1+$2}')
done

temp=$(echo $temp $tinc | awk '{print $1+$2}')

done

else
echo "Skipping to plotting"
fi

filetoplot2=energyplot.txt
python2 plot.py << EOF
$num_atoms
$filetoplot
$DOF
$system
EOF
for filetoplot2 in ./energyplot*
do
python2 plot.py << EOF
$num_atoms
$filetoplot2
$DOF
$system
EOF
#display $filetoplot2.png &
done
#display $filetoplot.png &	#Show percentage to total energy
