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
Ny=20
Nz=20
num_atoms=800

DOF=9
system=0
i=0
te=0
tcount=0
#---------------------------------------------------------------------------------------
disordermoves=$((num_atoms*0))
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
    totsteps=10
    stepsinc=1000
    end_steps=$((totsteps +1))
    steps=$((totsteps*tempsteps))

#--------------------------------------------------------------------------------
    while [ 0 -lt $(echo $totsteps $end_steps | awk '{if ($1<=$2) print 1; else print 0;}') ]
      do 
      i=$((i+1))
      te=$(echo $temp | awk '{print $1*1000}')
      vary=$totsteps

      sed -i "/variable disorder equal/c\variable disorder equal "$disordermoves"" $file	
      sed -i "/variable iter_steps loop/c\variable iter_steps loop "$totsteps"" $file
      sed -i "/variable iter_sitemax loop/c\variable iter_sitemax loop "$tempsteps"" $file
      sed -i "/variable T equal/c\variable T equal "$temp"" $file
      sed -i "/variable Tdecrease equal/c\variable Tdecrease equal v_kT-"$tinc"" $file
      sed -i "/dump 1 all custom 1 dumpmc/c\dump 1 all custom 1 dumpmc"$temp".lammpstrj id type xs ys zs " $file

      python insertpair.py > testmc.xyz
      #mpirun -np 2 lammps-daily <in.1dmc >temp$i.txt
      lammps-daily < in.1dmc >temp$i.txt
      tail -n 14 temp$i.txt >> ./data/outputT$te.txt

      #rm ./temp.txt

      search=$(grep "final energy" ./temp$i.txt)
      energy=$(echo $search | awk '{print $4}')
      echo "total moves: "$vary "Temp: " $temp "Energy: " $energy

#---------------------------------------------------------------

totsteps=$(echo $totsteps $stepsinc | awk '{print $1+$2}')
done

temp=$(echo $temp $tinc | awk '{print $1+$2}')

done
else
echo "Skipping to plotting"
fi

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
display energy.out.png &
