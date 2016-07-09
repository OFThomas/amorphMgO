#!/bin/bash

file=in.1dmc

python insertpair.py > testmc.xyz

disordermoves=200
totsteps=1000
temp=$(awk )

#declare -i numbersteps
#sed -i "1 c\\"$numbersteps" " in.1dmc
sed -i "/variable disorder equal/c\variable disorder equal "$disordermoves"" $file	
sed -i "/variable iter loop/c\variable iter loop "$totsteps"" $file
sed -i "/variable T equal/c\variable T equal "$temp"" $file
lammps-daily < in.1dmc >temp.txt
tail -n 14 temp.txt >> ./data/output.txt
#rm ./temp.txt

search=$(grep "final energy" ./temp.txt)
energy=$(echo $search | awk '{print $4}')

echo $i $energy >disorderplot.txt

#mv output.txt ./data/output.txt
#if [ $skip -eq 1 ] ; then
#	vmd dumpmc.lammpstrj
#else
#	echo "skipped"
#fi
more disorderplot.txt
