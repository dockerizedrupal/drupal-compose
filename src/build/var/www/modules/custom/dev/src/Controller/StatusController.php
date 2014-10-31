<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;

use Drupal\dev\Yaml\Containers\Containers;

use Docker\Docker;
use Docker\Http\DockerClient;

class StatusController extends ControllerBase {
  public function status() {
    $header = array(
      'id' => t('ID'),
      'name' => t('Name'),
      'image' => t('Image'),
    );

    $rows = array();

    $client = new DockerClient();
    $docker = new Docker($client);

    $manager = $docker->getContainerManager();

    $containers = $manager->findAll(array('all' => TRUE));

    foreach ((new Containers())->sortAll() as $name) {
      $row = array(
        'data' => array(),
      );

      $row['data'][] = 'id';
      $row['data'][] = $name;
      $row['data'][] = 'image';

//      if (!in_array($container->getName(), $containers)) {
//        continue;
//      }

//      $data = $container->getData();
//
//      $rows[] = array(
//        'data' => array(
//          $container->getId(),
//          $container->getName(),
//          $data['Image'],
//        ),
//      );

      $rows[] = $row;
    }

    $table = array(
      '#type' => 'table',
      '#header' => $header,
      '#rows' => $rows,
    );

    return $table;
  }
}
