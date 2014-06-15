if (!exists("outfilename")) outfilename='default'
if (!exists("infilename")) infilename='default'
if (!exists("heading")) heading='apachebench'
if (!exists("concurrency")) concurrency='c5'

set terminal png
set output outfilename
set title heading

set key left top
set grid y
set xdata time
set timefmt "%s"
set format x "%S"
set xlabel 'seconds during test'
set ylabel "response time (ms)"
set datafile separator '\t'

plot infilename every ::2 using 2:5 title 'response time' with points
