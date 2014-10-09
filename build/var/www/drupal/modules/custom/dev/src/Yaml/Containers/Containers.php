<?php

namespace Drupal\dev\Yaml\Containers;

use Drupal\Component\Graph\Graph;
use Drupal\Component\Utility\SortArray;
use Drupal\Core\Site\Settings;

use Drupal\dev\Yaml\Containers\ContainersInterface;
use Drupal\dev\Yaml\Yaml;

use Drupal\dev\Yaml\Container\Container;

class Containers implements ContainersInterface {
  protected $graph = array();
  protected $yaml = array();

  public function __construct() {
    $yaml = new Yaml(Settings::get('dev.yml'));

    $this->yaml = $yaml->toArray();
  }

  protected function getContainers() {
    $containers = array();

    foreach ($this->yaml['containers'] as $name => $container) {
      $containers[] = new Container($name, $container);
    }

    return $containers;
  }

  public function sortAll() {
    $graph = $this->getGraph();

    uasort($graph, array($this, 'sortGraph'));

    return array_keys($graph);
  }

  public function sortGraph(array $a, array $b) {
    $weight = SortArray::sortByKeyInt($a, $b, 'weight') * -1;

    if ($weight === 0) {
      return SortArray::sortByKeyString($a, $b, 'component');
    }

    return $weight;
  }

  public function getGraph() {
    if (!$this->graph) {
      $graph = array();

      foreach ($this->getContainers() as $container) {
        $name = $container->getName();

        $graph[$name]['edges'] = array();

        $links = $container->getLinks();

        if ($links) {
          foreach ($links as $link) {
            $graph[$name]['edges'][$link] = TRUE;
          }
        }
      }

      $this->graph = (new Graph($graph))->searchAndSort();
    }

    return $this->graph;
  }
}
