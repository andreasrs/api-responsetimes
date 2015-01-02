URLPHALCON=http://phalcon.test.local/
URLPHALCONREACT=http://phalcon-react.test.local/
URLZF2=http://zf2.test.local/
URLHAPI=http://hapi.test.local:8080/
URLSILEX=http://silex.test.local/

all: warmup bench-phalcon bench-phalcon-react bench-zf2 bench-hapi bench-silex graph

clean:
	rm -rf results/*

warmup:
	@echo Warming up the bench targets
	ab -n 500 -c 5 $(URLPHALCON)
	ab -n 500 -c 5 $(URLPHALCONREACT)
	ab -n 500 -c 5 $(URLZF2)
	ab -n 500 -c 5 $(URLHAPI)
	ab -n 500 -c 5 $(URLSILEX)

bench-phalcon:
	@echo Generating traffic and logging data for $(URLPHALCON)
	sleep 3
	ab -n 10000 -c 5 -g results/bench-phalcon-c5.dat $(URLPHALCON)
	sleep 3
	ab -n 10000 -c 100 -g results/bench-phalcon-c100.dat $(URLPHALCON)

bench-phalcon-react:
	@echo Generating traffic and logging data for $(URLPHALCONREACT)
	sleep 3
	ab -n 10000 -c 5 -g results/bench-phalcon-react-c5.dat $(URLPHALCONREACT)
	sleep 3
	ab -n 10000 -c 100 -g results/bench-phalcon-react-c100.dat $(URLPHALCONREACT)

bench-zf2:
	@echo Generating traffic and logging data for $(URLZF2)
	sleep 3
	ab -n 10000 -c 5 -g results/bench-zf2-c5.dat $(URLZF2)
	sleep 3
	ab -n 10000 -c 100 -g results/bench-zf2-c100.dat $(URLZF2)

bench-hapi:
	@echo Generating traffic and logging data for $(URLHAPI)
	sleep 3
	ab -n 10000 -c 5 -g results/bench-hapi-c5.dat $(URLHAPI)
	sleep 3
	ab -n 10000 -c 100 -g results/bench-hapi-c100.dat $(URLHAPI)

bench-silex:
	@echo Generating traffic and logging data for $(URLSILEX)
	sleep 3
	ab -n 10000 -c 5 -g results/bench-silex-c5.dat $(URLSILEX)
	sleep 3
	ab -n 10000 -c 100 -g results/bench-silex-c100.dat $(URLSILEX)

graph:
	@echo Plotting logged data to graph
	gnuplot -e "outfilename='results/line-c5.png';concurrency='c5';heading='10000 total requests, 5 concurrent'" plot.p
	gnuplot -e "outfilename='results/line-c100.png';concurrency='c100';heading='10000 total requests, 100 concurrent'" plot.p

	gnuplot -e "infilename='results/bench-phalcon-c5.dat';outfilename='results/dot-bench-phalcon-c5.png';concurrency='c5';heading='10000 total requests, 5 concurrent'" plot-scatter.p
	gnuplot -e "infilename='results/bench-phalcon-c100.dat';outfilename='results/dot-bench-phalcon-c100.png';concurrency='c100';heading='10000 total requests, 100 concurrent'" plot-scatter.p

	gnuplot -e "infilename='results/bench-phalcon-react-c5.dat';outfilename='results/dot-bench-phalcon-react-c5.png';concurrency='c5';heading='10000 total requests, 5 concurrent'" plot-scatter.p
	gnuplot -e "infilename='results/bench-phalcon-react-c100.dat';outfilename='results/dot-bench-phalcon-react-c100.png';concurrency='c100';heading='10000 total requests, 100 concurrent'" plot-scatter.p

	gnuplot -e "infilename='results/bench-zf2-c5.dat';outfilename='results/dot-bench-zf2-c5.png';concurrency='c5';heading='10000 total requests, 5 concurrent'" plot-scatter.p
	gnuplot -e "infilename='results/bench-zf2-c100.dat';outfilename='results/dot-bench-zf2-c100.png';concurrency='c100';heading='10000 total requests, 100 concurrent'" plot-scatter.p

	gnuplot -e "infilename='results/bench-hapi-c5.dat';outfilename='results/dot-bench-hapi-c5.png';concurrency='c5';heading='10000 total requests, 5 concurrent'" plot-scatter.p
	gnuplot -e "infilename='results/bench-hapi-c100.dat';outfilename='results/dot-bench-hapi-c100.png';concurrency='c100';heading='10000 total requests, 100 concurrent'" plot-scatter.p

	gnuplot -e "infilename='results/bench-silex-c5.dat';outfilename='results/dot-bench-silex-c5.png';concurrency='c5';heading='10000 total requests, 5 concurrent'" plot-scatter.p
	gnuplot -e "infilename='results/bench-silex-c100.dat';outfilename='results/dot-bench-silex-c100.png';concurrency='c100';heading='10000 total requests, 100 concurrent'" plot-scatter.p
