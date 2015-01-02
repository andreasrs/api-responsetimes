if (!exists("outfilename")) outfilename='default'
if (!exists("heading")) heading='apachebench'
if (!exists("concurrency")) concurrency='c5'

set terminal png
set output outfilename
set title heading
set grid y
set xlabel "request"
set ylabel "response time (ms)"

#infiles hardcoded
plot "results/bench-zf2-".concurrency.".dat" using 9 smooth sbezier with lines title "PHP: ZF2 with opcache", \
"results/bench-phalcon-".concurrency.".dat" using 9 smooth sbezier with lines title "PHP: Phalcon with opcache", \
"results/bench-phalcon-react-".concurrency.".dat" using 9 smooth sbezier with lines title "PHP: Phalcon + react with opcache", \
"results/bench-hapi-".concurrency.".dat" using 9 smooth sbezier with lines title "node.js: hapi", \
"results/bench-silex-".concurrency.".dat" using 9 smooth sbezier with lines title "PHP: Silex with opcache"
