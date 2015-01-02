var cluster = require('cluster');
var numCPUs = require('os').cpus().length;

if (cluster.isMaster) {

    for (var i = 0; i < numCPUs; i++) {
        cluster.fork();
    }

    cluster.on('exit', function(worker, code, signal) {
        console.log('Worker ' + worker.process.pid + ' is no longer running.');
    });

} else {

    var Hapi = require("hapi");
    var server = new Hapi.Server(8080, "localhost");

    server.start(function() {
        console.log("Started nodejs server for benchmarking.");
    });

    server.route({
        path: "/",
        method: "GET",
        handler: function(request, reply) {
            require('../plugins/http')(reply);
        }
    });

}

