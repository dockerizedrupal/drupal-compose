<?php

namespace Drupal\dev\Plugin\Block;

use Drupal\Core\Block\BlockBase;

/**
 * @Block(
 *   id = "dev_actions",
 *   subject = @Translation("Actions"),
 *   admin_label = @Translation("Actions")
 * )
 */
class ActionsBlock extends BlockBase {
  public function build() {
    return array(
      '#type' => 'markup',
      '#markup' => 'ActionsBlock',
    );
  }
}
