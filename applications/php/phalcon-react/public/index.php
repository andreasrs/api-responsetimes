<?php

try {
    require '../vendor/autoload.php';

    $loader = new \Phalcon\Loader();
    $loader->registerDirs(array(
        '../controllers/',
        '../models/'
    ))->register();

    $di = new Phalcon\DI\FactoryDefault();

    $di->set('view', function(){
        $view = new \Phalcon\Mvc\View();
        $view->setViewsDir('../views/');
        return $view;
    });

    $di->set('url', function(){
        $url = new \Phalcon\Mvc\Url();
        $url->setBaseUri('/');
        return $url;
    });

    //Handle the request
    $application = new \Phalcon\Mvc\Application($di);
    echo $application->handle()->getContent();

} catch(\Phalcon\Exception $e) {
    echo "PhalconException: ", $e->getMessage();
}

