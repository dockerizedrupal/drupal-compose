<?php

namespace Drupal\dev\Yaml;

use Symfony\Component\Yaml\Yaml as SymfonyYaml;

use Drupal\dev\Yaml\YamlInterface;

class Yaml implements YamlInterface {
  protected $filepath = '';

  public function __construct($filepath) {
    $this->filepath = $filepath;
  }

  public function toArray() {
    return SymfonyYaml::parse($this->filepath);
  }

  public function __toString() {
    return file_get_contents($this->filepath);
  }
}
