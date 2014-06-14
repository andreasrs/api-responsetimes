<?php
use Phalcon\Mvc;
use Phalcon\Http\Client\Request;

class IndexController extends Mvc\Controller {
    const numExternalRequests = 10;

    public function indexAction() {
        $this->view->disable();
        $this->response->setContentType('application/json', 'UTF-8');

        // react php setup
        $loop = \React\EventLoop\Factory::create();
        $dnsResolverFactory = new \React\Dns\Resolver\Factory();
        $dnsResolver = $dnsResolverFactory->createCached('8.8.8.8', $loop);

        $factory = new \React\HttpClient\Factory();
        $client = $factory->create($loop, $dnsResolver);

        // the callback event will push completed responses to this array
        $completeResponses = [];

        // set up 10 async http operations with react
        for($i=0;$i<self::numExternalRequests;$i++) {
            $request = $client->request('GET', 'http://127.0.0.1:9200/entitylib/entity/_search?s=' . $i);
            $request->on('response', function ($response) use (&$completeResponses) {
                $buffer = '';

                $response->on('data', function ($data) use (&$buffer) {
                    $buffer .= $data;
                });

                $response->on('end', function ($response) use (&$buffer, &$completeResponses) {
                    $completeResponses[] = json_decode($buffer, true);
                    if (count($completeResponses) == self::numExternalRequests) {
                        echo(json_encode($completeResponses));
                    }
                });
            });

            $request->on('end', function ($error, $response) {
                echo $error;
            });

            $request->end();
        }

        // start react eventloop
        $loop->run();
    }

}

