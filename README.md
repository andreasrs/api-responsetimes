webservice-aggregator-comparison
==========================

Evaluating some technologies. A set of micro webservices that fetch the same amount of content over network (triggers I/O resources) and then build a new JSON structure (triggers CPU resources) from this before returning it to the client in a JSON format with the correct HTTP headers set.

The purpose of this set of tests is to get an overall impression on "how a technology stack may tend to perform" with the following scenario:

* Listens on a TCP port
* Accepts a HTTP GET on one single endpoint (/)
* This endpoint triggers 10 individual TCP+HTTP server-to-server network requests to an external resouce and stores the result in memory. This will trigger network I/O on the system under test.
* The external resources are JSON decoded and then we create a new response object based on that data. This will trigger some CPU usage on the system under test (basic iterations and a runthrough of JSON serialization/deserialization)

This may be a useful reference when a high-availability and high-performant webservice is needed. Please utilize your favourte stack+framework and an awesome HTTP reverse proxy cache like Varnish if you do not have these requirements.

The results posted in this README contacts an elasticsearch instance running on the same machine. All the tests are run on the same data and external variables to reduce ambiguity.

