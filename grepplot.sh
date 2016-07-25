#!/bin/bash

i=$1
te=$2
steps=$3
echo $i $te $steps

gnome-terminal -e "tail -f energyplot$i+$te.dat" --window-with-profile=tails &
for j in $(eval echo "{3501..$steps}")
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

  searchratio=$(grep "^moves = $((j-500))" ./temp$i.txt )
  accpt_moves=$(echo $searchratio | awk '{print $8}')
  echo $j $accpt_moves >> ratioplot$i+$te.dat
done 

