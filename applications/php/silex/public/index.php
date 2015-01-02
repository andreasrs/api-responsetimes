<?php

require_once __DIR__.'/../vendor/autoload.php';

$app = new Silex\Application();

$app->get('/', function () use ($app) {

    $responses = [];

    // 10 external I/O network events
    for ($i=0;$i<10;$i++) {
        $responses[] = json_decode(httpGet('http://localhost:9200/entitylib/entity/_search?s=' . $i), true);
    }

    // create a new response structure using our fetched data
    $result = array(
        'date' => time(),
        'shards' => $responses[0]['_shards']['total'],
        'hits' => $responses[9]['hits']['hits']
    );

    // construct object further with a bit of iteration
    for ($i=0;$i<10;$i++) {
        $result['hits'][] = $responses[$i]['hits']['hits'][0];
    }

    // output the JSON encoded result
    return $app->json($result);
});

$app->run();

function httpGet($url) {
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_URL => $url,
        CURLOPT_USERAGENT => 'Phalcon'
    ));

    $resp = curl_exec($curl);
    curl_close($curl);

    return $resp;
}

