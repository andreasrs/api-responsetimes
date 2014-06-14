<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Zend\View\Model\JsonModel;

class IndexController extends AbstractActionController {
    public function indexAction() {
        $responses = [];

        // 10 external I/O network events
        for ($i=0;$i<10;$i++) {
            $client = new \Zend\Http\Client('http://localhost:9200/entitylib/entity/_search?s=' . $i, array(
                'adapter'   => 'Zend\Http\Client\Adapter\Curl',
                'curloptions' => array(CURLOPT_FOLLOWLOCATION => true),
            ));

            $responses[] = json_decode($client->send()->getContent(), true);
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

        // output the JSON result
        return new JsonModel($result);
    }
}
