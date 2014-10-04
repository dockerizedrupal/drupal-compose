<?php

/**
 * @file
 * Contains \Drupal\composer_manager\ComposerManager.
 */

namespace Drupal\composer_manager;

/**
 * Interface for manager objects.
 */
interface ComposerManagerInterface {

  /**
   * Prepares and returns the realpath to the Composer file directory.
   *
   * @return string
   *
   * @throws \RuntimeException
   */
  public function getComposerFileDirectory();

  /**
   * Returns the consolidated composer.json file.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface
   */
  public function getComposerJsonFile();

  /**
   * Returns consolidated composer.lock file.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface
   */
  public function getComposerLockFile();

  /**
   * Reads the consolidated composer.lock file and parses in to a PHP array.
   *
   * @return array
   *
   * @throws \RuntimeException
   */
  public function readComposerLockFile();

  /**
   * Returns the absolute path to the vendor directory.
   *
   * @return string
   */
  public function getVendorDirectory();

  /**
   * Returns the absolute path to the autoload.php file.
   *
   * @return string
   */
  public function getAutoloadFilepath();

  /**
   * Returns an associative array of packages included in core to version.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface
   */
  public function getCorePackages();

  /**
   * Returns TRUE if the Composer Manager module is configured to automatically
   * build the consolidated composer.json file or Drupal is being run via the
   * command line (Drush assumed).
   *
   * @return bool
   */
  public function autobuildComposerJsonFile();

  /**
   * Registers the autoloader.
   *
   * @throws \RuntimeException
   */
  public function registerAutolaoder();
}
