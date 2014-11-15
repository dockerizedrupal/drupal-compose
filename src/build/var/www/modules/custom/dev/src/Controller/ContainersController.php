<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;

use Docker\Docker;
use Docker\Http\DockerClient;

class ContainersController extends ControllerBase {
  public function containers() {
    $header = array(
      'id' => t('ID'),
      'name' => t('Name'),
      'image' => t('Image'),
    );

    $rows = array();

    $client = new DockerClient();
    $docker = new Docker($client);

    $manager = $docker->getContainerManager();

    foreach ($manager->findAll(array('all' => TRUE)) as $container) {
      $config = $container->getConfig();
      $data = $container->getData();
      $env = $container->getEnv();

      $rows[] = array(
        'data' => array(
          $container->getId(),
          $container->getName(),
          $data['Image'],
        ),
      );
    }

    $table = array(
      '#type' => 'table',
      '#header' => $header,
      '#rows' => $rows,
    );

    return $table;
  }
}