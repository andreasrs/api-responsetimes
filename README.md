Disclaimer
=========

This project contains some applications that can be bombed using apachebench(ab) or siege. The applications implement a theoretical but realistic scenario implemented in different languages/frameworks. All examples result in the same output; solving the problem in a "realistic" way within the scope of given tools.

This CAN be useful to get an overview on how the technologies behave with default/sane settings on a given machine, but should not be considered as absolute evidence as "the best framework for x" or "runtime x is so much better than y" alone. Use COMMON SENSE when interpreting the results, and be sure to study and understand what the applications actually do. All the code is there. The primary goals is to get a basic idea and overview of the baseline responsetimes to expect when creating a new API using these modern frameworks.

webservice-aggregator-comparison
==========================

A set of micro webservices that fetch the same amount of content over network (triggers I/O resources...) and then build a new JSON structure (triggers CPU resources...) from this before returning it to the client in a JSON format with the correct HTTP headers set. It basically emulates a typical webservice that fetches content from different sources and uses these to compile an aggregated result to the client.

The purpose of this set of tests is to get an overall impression on "how a technology stack may tend to perform" with the following scenario:

* Listen on a TCP port for HTTP GET requests
* Accepts HTTP GET on an endpoint (/)
* This endpoint when receiving a valid GET request triggers 10 individual HTTP server-to-server requests to an "external" (TCP) resouce and stores the result in memory within the application. This will trigger network I/O and simulates similar operations in a real API.
* The external resources are JSON decoded upon retrieval and we then we thn start to create a NEW response object based on a subset of that received data. This will trigger some CPU usage on the system under test (basic iterations and a runthrough of JSON serialization/deserialization).

This may be a useful reference when a high-availability and high-performant webservice that depends on external network-resources is needed, but you are unsure which technology has an acceptable responsetime *baseline* using sane minimalistic defaults.

The results posted in this README contacts an elasticsearch instance running on the same machine on 0.0.0.0:9200 as the "external resource". All the tests are run on the same data and other external variables are kept as similar as possible to reduce ambiguity. In situations where the tests hit an absolute limit or start degrading we can assume that the external I/O dependant resouce is the bottleneck and not the particular application stack.

Feel free to clone the tests and run it on your own systems. In order to keep things consistent this README will only contain numbers from my own system.

Writing good and realistic mini-tests that give an impression of performance potential baselines of different tech stacks is potentially very useful in a selection process, but also has many possible pitfalls (and some will argue completely flawed...), and so I'm happy if people want to comment or fire pullrequests to help make this more useful for everyone!

Stacks currently included, grouped by language
========================
PHP:

Zend Framework 2.3 @ Apache/2.4.9 (Unix) + PHP 5.5.13
Zend Framework 2.3 @ Apache/2.4.9 (Unix) + PHP 5.5.13 + zend_extension=opcache.so

Phalcon Framwork 1.3.2 @ Apache/2.4.9 (Unix) + PHP 5.5.13
Phalcon Framwork 1.3.2 @ Apache/2.4.9 (Unix) + PHP 5.5.13 + zend_extension=opcache.so
Phalcon Framwork 1.3.2 @ Apache/2.4.9 (Unix) + PHP 5.5.13 + zend_extension=opcache.so + eventlib + REACT PHP

node.js:

Hapi 6.0.1 @ node v0.10.29

Restify @ TODO

Express.js @ TODO

Results:
=======
TODO

Running conclusion:
================
* ZF2 is terrible for this particular type of job. I have looked at the entire callstack using XDEBUG because the results were so awful. To summarize ZF2 is CPU-bound quickly as a result of over 900 individual PHP function calls for this simple task of fetching external data and then building a response. Some of these function calls are dynamic PHP call_user_func(...); that take place in order to bootstrap the ZF2 ServiceManager and EventManager at the beginning. These call_user_func and similar are hard for PHP opcache or other optimizers to speed up. At the moment I therefore view ZF2 as unviable for these usecases because of the CPU-intensive overhead. For a very low amount of concurrent requests it does work fine, but you will have to start throwing more hardware at it very fast in order to avoid longer responsetimes. And these tests are all about responsetimes at different amounts of stress!
* Phalcon is viable, and is much closer to "raw PHP" as it does not run a whole lot of PHP code upon every request that is hard to optimize via opcache. The Phalcon core functionality is all coded in C and exposed via. a compiled module.
* node.js frameworks perform well and as expected on this type of thing and can be used with good responsetimes

At the moment I am a little surprised that the synchronous (I/O) Phalcon application keeps up so well with node. I would have expected the async I/O running in the node.js applications to pull away more as we do actually perform 10 external http requests for each response we generate. I do however expect the async I/O in nodejs will pay off more in an environment where individual waits on the external resource increase. Elasticsearch is pretty awesome and does not punish synchronous I/O a lot here.

ReactPHP was a bit disappointing as it overall turns out SLOWER than simply running the HTTP requests in a synchronous way from PHP in this particular case. I am no experienced user of this framework and so this could also be a mistake in the implementation. I DID however install and verify that the "eventlib" C extension was installed in order to help ReactPHP performance. I have not taken the time to look at XDEBUG output yet.

Again, this is fairly tricky stuff to "test", so please keep an open and critical mind when interpreting these results.
