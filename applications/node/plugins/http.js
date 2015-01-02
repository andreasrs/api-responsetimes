module.exports = function(output) {
    var async = require('async');
    var http = require('http');

    var agent = new http.Agent();
    agent.maxSockets = 10;

    var tasks = [];
    var responses = [];

    for(var i=0; i<10; i++) {
        tasks.push(function(finished) {
            var options = {
                host: 'localhost',
                port: 9200,
                path: '/entitylib/entity/_search',
                agent: agent
            };

            var req = http.request(options, function(response) {
                response.setEncoding('utf8');
                var buffer = '';

                response.on('data', function(chunk) {
                    buffer += chunk;
                });

                response.on('end', function() {
                    responses.push(JSON.parse(buffer));
                    finished();
                });
            });

            req.end();
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

            output(resp);
        }
    });
};

