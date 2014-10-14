<?php

namespace Drupal\dev\Yaml\Container;

use Drupal\dev\Yaml\Container\ContainerInterface;

class Container implements ContainerInterface {
  protected $name = '';
  protected $container = array();

  public function __construct($name, array $container) {
    $this->name = $name;
    $this->container = $container;
  }

  public function getName() {
    return $this->name;
  }

  public function getLinks() {
    return isset($this->container['links']) ? $this->container['links'] : array();
  }
}
