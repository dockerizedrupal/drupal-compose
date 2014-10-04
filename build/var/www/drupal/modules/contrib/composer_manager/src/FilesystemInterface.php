<?php

/**
 * @file
 * Contains \Drupal\composer_manager\FilesystemInterface.
 */

namespace Drupal\composer_manager;

interface FilesystemInterface {

  /**
   * Returns whether the file path is an absolute path.
   *
   * @param string $filepath
   *    A file path.
   *
   * @return bool
   */
  public function isAbsolutePath($filepath);

  /**
   * Given an existing path, convert it to a path relative to a given starting
   * path.
   *
   * @param string $end_path
   *   Absolute path of target
   * @param string $startPath
   *   Absolute path where traversal begins
   *
   * @return string
   *   Path of target relative to starting path
   */
  public function makePathRelative($end_path, $start_path);

  /**
   * Ensures the directory is created and protected via an .htaccess file if
   * is created in a public directory.
   *
   * @param string $directory
   *   The URI or path to the directory being prepared.
   *
   * @return bool
   */
  public function prepareDirectory($directory);
}
