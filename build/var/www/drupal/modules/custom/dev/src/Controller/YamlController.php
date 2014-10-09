<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Site\Settings;

use Drupal\dev\Yaml\Yaml;

class YamlController extends ControllerBase {
  public function yaml() {
    $yaml = new Yaml(Settings::get('dev.yml'));

    return array(
      '#theme' => 'yaml',
      '#yaml' => $yaml,
    );
  }
}
