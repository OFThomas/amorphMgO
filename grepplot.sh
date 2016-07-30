#!/bin/bash

i=$1
te=$2
steps=$3
echo $i $te $steps

rm ./energyplot$i+$te.dat && rm ./ratioplot$i+$te.dat
#gnome-terminal -e "tail -f energyplot$i+$te.dat" --window-with-profile=tails &
#gnome-terminal -e "tail -f ratioplot$i+$te.dat" --window-with-profile=tails &
for j in $(eval echo "{20000..$steps..4}")
    ###for j in {1..500}
    do
    if [ $j -lt 1000 ]; then 
	searchenergy=$(grep "^     $j" ./temp$i.txt)
    elif [[ $j -gt 999 ]] && [[ $j -lt 10000 ]]; then
	searchenergy=$(grep "^    $j" ./temp$i.txt)
    else
	searchenergy=$(grep "^   $j" ./temp$i.txt)
    fi
  stepenergy=$(echo $searchenergy | awk '{print $5}')
  echo $j $stepenergy >> energyplot$i+$te.dat

  searchratio=$(grep "^moves = $((j-4999))" ./temp$i.txt )
  accpt_moves=$(echo $searchratio | awk '{print $8}')
  echo $j $accpt_moves >> ratioplot$i+$te.dat
done 

for filetoplot in ./energyplot$i+$te.dat
do
python2 plot.py << EOF
72
$filetoplot
9
0
EOF
display $filetoplot.png &
done

for filetoplot2 in ./ratioplot$i+$te.dat
do
python2 plot.py << EOF
72
$filetoplot2
9
1
EOF
display $filetoplot2.png &
done
