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
