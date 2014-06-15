<?php

use Phalcon\Mvc;
use Phalcon\Http\Client\Request;

class IndexController extends Mvc\Controller {

    public function indexAction() {
        $this->view->disable();
        $this->response->setContentType('application/json', 'UTF-8');

        $responses = [];

        // 10 external I/O network events
        for ($i=0;$i<10;$i++) {
            $responses[] = json_decode($this->httpGet('http://localhost:9200/entitylib/entity/_search?s=' . $i), true);
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
        echo(json_encode($result));
    }

    // minimalistic HTTP GET using cURL, Phalcon does not have a wrapper yet?
    private function httpGet($url) {
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

}

