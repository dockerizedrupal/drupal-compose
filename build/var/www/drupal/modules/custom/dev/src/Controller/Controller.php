<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;

class Controller extends ControllerBase {
  public function dev() {
    $element = array(
      '#markup' => 'Hello, world',
    );

    return $element;
  }
}
