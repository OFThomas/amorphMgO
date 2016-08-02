#!/bin/bash
rm ./energy.out
file=in.1dmc
#Generate test atom arrangement
python insertpair.py > testmc.xyz
#---- 0 to run lammps
#---- 1 to skip to plotting
skip=0

seed=582783
#seed=4827938
#Fitting params
Ny=6
Nz=6
num_atoms=72

DOF=9
system=0
i=0
te=0
tcount=0
#---------------------------------------------------------------------------------------
disordermoves=$((num_atoms*10))
disinc=50
end_dis=$((disordermoves+1))

temp=0.026
end_temp=0.027
tinc=0.026
#------------------------------------------------------------------------------------
ydim=$(echo $Ny | awk '{print $1*2.106}')
zdim=$(echo $Nz | awk '{print $1*2.106}')

sed -i "/region box block/c\region box block 0.0 4.212 0.0 "$ydim" 0.0 "$zdim" units box" $file

if [ $skip -eq 0 ]; then
  rm ./disorderplot.dat

  sed -i "/variable seed equal/c\variable seed equal "$seed"" $file	
  while [ 0 -lt $(echo $temp $end_temp | awk '{if ($1<=$2) print 1; else print 0;}') ]
    do 
    tcount=$((tcount+1))
#--------------------------------------------------------------------------------
    tempsteps=$num_atoms
    totsteps=70
    stepsinc=1000
    end_steps=$((totsteps +1))
    steps=$((totsteps*tempsteps))

#--------------------------------------------------------------------------------
    while [ 0 -lt $(echo $totsteps $end_steps | awk '{if ($1<=$2) print 1; else print 0;}') ]
    #while [ 0 -lt $(echo $disordermoves $end_dis | awk '{if ($1<=$2) print 1; else print 0;}') ]
      do 
      i=$((i+1))
      te=$(echo $temp | awk '{print $1*1000}')
      #vary=$disordermoves
      vary=$totsteps

      sed -i "/variable disorder equal/c\variable disorder equal "$disordermoves"" $file	
      sed -i "/variable iter_steps loop/c\variable iter_steps loop "$totsteps"" $file
      sed -i "/variable iter_sitemax loop/c\variable iter_sitemax loop "$tempsteps"" $file
      #sed -i "/variable iter loop/c\variable iter loop "$disordermoves"" $file
      sed -i "/variable T equal/c\variable T equal "$temp"" $file
      sed -i "/variable Tdecrease equal/c\variable Tdecrease equal v_kT-"$tinc"" $file
      sed -i "/dump 1 all custom 1 dumpmc/c\dump 1 all custom 1 dumpmc"$temp".lammpstrj id type xs ys zs " $file

      #mpirun -np 2 lammps-daily <in.1dmc >temp$i.txt
      lammps-daily < in.1dmc >temp$i.txt
      tail -n 14 temp$i.txt >> ./data/outputT$te.txt

      #rm ./temp.txt

      search=$(grep "final energy" ./temp$i.txt)
      energy=$(echo $search | awk '{print $4}')
      #echo "Disorder moves: "$vary "Temp: " $temp "Energy: " $energy
      echo "total moves: "$vary "Temp: " $temp "Energy: " $energy
      #echo $vary $energy >> disorderplot.dat

      #mv output.txt ./data/output.txt
      #if [ $skip -eq 1 ] ; then
       #	vmd dumpmc.lammpstrj
      #else
       #	echo "skipped"
      #fi
      #more disorderplot.txt



#----------------- Energy plot every step--------------
#./grepplot.sh $i $te $steps
#rm ./energyplot$i+$te.dat
#rm ./ratioplot$i+$te.dat

#for j in $(eval echo "{5001..$steps}")
    #for j in {1..500}
#    do
#    if [ $j -lt 1000 ]; then 
#	searchenergy=$(grep "^     $j" ./temp.txt)
#    elif [[ $j -gt 999 ]] && [[ $j -lt 10000 ]]; then
#	searchenergy=$(grep "^    $j" ./temp.txt)
#    else
#	searchenergy=$(grep "^   $j" ./temp.txt)
#    fi
#  stepenergy=$(echo $searchenergy | awk '{print $5}')
#  echo $j $stepenergy >> energyplot$i+$te.dat

  #searchratio=$(grep "^moves = $((j-500))" ./temp.txt )
  #accpt_moves=$(echo $searchratio | awk '{print $8}')
  #echo $j $accpt_moves >> ratioplot$i+$te.dat
#done 
#-----------------------------------------------------------------

#disordermoves=$(echo $disordermoves $disinc | awk '{print $1+$2}')
totsteps=$(echo $totsteps $stepsinc | awk '{print $1+$2}')
done

temp=$(echo $temp $tinc | awk '{print $1+$2}')

done
else
echo "Skipping to plotting"
fi

#for filetoplot in ./energyplot*
#do
#python2 plot.py << EOF
#$num_atoms
#$filetoplot
#$DOF
#0
#EOF
#display $filetoplot.png &
#done

#for filetoplot2 in ./ratioplot*
#do
#python2 plot.py << EOF
#$num_atoms
#$filetoplot2
#$DOF
#1
#EOF
#display $filetoplot2.png &
#done
#for filetoplot3 in ./disorderplot*
#do
#python2 plot.py << EOF
#$num_atoms
#$filetoplot3
#$DOF
#$system
#EOF
#display $filetoplot2.png &
#done
#display $filetoplot3 &	#Show percentage to total energy
tail -n 14 temp$i.txt
python quickplot.py
