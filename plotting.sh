#!/bin/bash
for filetoplot in ./energyplot*.dat
do
python2 plot.py << EOF
72
$filetoplot
9
0
EOF
display $filetoplot.png &
done
for filetoplot2 in ./ratioplot*
do

python2 plot.py << EOF
$num_atoms
$filetoplot2
$DOF
1
EOF
display $filetoplot2.png &
done
