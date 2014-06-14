var cluster = require('cluster');
var numCPUs = require('os').cpus().length;

if (cluster.isMaster) {

    // as we want to get a realistic impression of baseline performance, make sure we utilize available system cores
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', function(worker, code, signal) {
    console.log('Worker ' + worker.process.pid + ' is no longer running.');
  });

} else {
    var Hapi = require("hapi");
    var server = new Hapi.Server(8080, "0.0.0.0");

    var http = require('http');
    var async = require('async');
    var elasticsearch = require('elasticsearch');

    var client = elasticsearch.Client({
        host: 'localhost:9200',
        sniffOnStart: true
    });

    server.start(function() {
        console.log("Started nodejs server for benchmarking.");
    });

    server.route({
        path: "/",
        method: "GET",
        handler: function(request, reply) {
            var tasks = [];
            var responses = [];

            // async network io task queue
            for(var i=0; i<10; i++) {
                tasks.push(function(finished) {
                    client.search({
                        index: 'entitylib',
                        size: 50,
                    }).then(function(resp) {
                        responses.push(resp);
                        finished();
                    });
                });
            }

            // perform async network io tasks
            async.parallel(tasks, function(err) {
                if (err) {
                    console.log(err);
                } else {
                    // all tasks complete, construct base repsonse object
                    var resp = {
                        'time': new Date().getTime(),
                        'shards': responses[0]._shards.total,
                        'hits': []
                    };

                    // iteratate over remote response objects and put a selection from it into our own resulting response
                    for(var i=0;i<10;i++) {
                        resp.hits.push(responses[i].hits.hits[0]);
                    }

                    reply(resp);
                }
            });
        }
    });

}

