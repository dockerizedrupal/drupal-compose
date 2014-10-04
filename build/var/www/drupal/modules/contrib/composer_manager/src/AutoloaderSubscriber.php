<?php

/**
 * @file
 * Contains \Drupal\composer_manager\AutoloaderSubscriber.
 */

namespace Drupal\composer_manager;

use Drupal\composer_manager\ComposerManagerInterface;
use Drupal\Core\Url;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

class AutoloaderSubscriber implements EventSubscriberInterface {

  /**
   * @var \Drupal\composer_manager\ComposerManagerInterface
   */
  protected $manager;

  /**
   * @param \Drupal\composer_manager\ComposerManagerInterface $manager
   */
  public function __construct(ComposerManagerInterface $manager) {
    $this->manager = $manager;
  }

  /**
   * Implements \Symfony\Component\EventDispatcher\EventSubscriberInterface::getSubscribedEvents().
   */
  public static function getSubscribedEvents() {
    return array(
      KernelEvents::REQUEST => array('onRequest', 999),
    );
  }

  /**
   * Registers the autoloader.
   */
  public function onRequest(GetResponseEvent $event) {
    try {
      $this->manager->registerAutolaoder();
    }
    catch (\RuntimeException $e) {
      if (PHP_SAPI !== 'cli') {
        watchdog_exception('composer_manager', $e, NULL, array(), WATCHDOG_WARNING);
      }
    }
  }

}
