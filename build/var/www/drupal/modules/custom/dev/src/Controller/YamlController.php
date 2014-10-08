<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Site\Settings;

class YamlController extends ControllerBase {
  public function yaml() {
    return array(
      '#theme' => 'yaml',
      '#yaml' => file_get_contents(Settings::get('src') . '/dev.yml'),
    );
  }
}
