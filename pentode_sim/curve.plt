## gnuplot control 
##set size 0.5, 0.5
##set term png size 600, 400
set style line 1 lt 2 lw 2 pt 3 ps 0.5
set grid lt 2
##show  grid 
set xtics 20
set mxtic 5
set ytics 10
set mytics 5
set xlabel 'volts'
set ylabel 'current (mAs)'
set key autotitle columnheader
stats 'data.dat' using 0 nooutput
plot for [i=0:(STATS_blocks - 1)] 'data.dat' using 2:4 index i \
     with lines
pause 60
reread