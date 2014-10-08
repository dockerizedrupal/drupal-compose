<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;

class StatusController extends ControllerBase {
  public function status() {
    return array(
      '#markup' => 'Status',
    );
  }
}
