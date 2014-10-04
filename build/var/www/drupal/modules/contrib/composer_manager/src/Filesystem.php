<?php

/**
 * @file
 * Contains \Drupal\composer_manager\Filesystem.
 */

namespace Drupal\composer_manager;

class Filesystem implements FilesystemInterface {

  /**
   * Returns whether the file path is an absolute path.
   *
   * @param string $filepath
   *    A file path.
   *
   * @return bool
   *
   * @see https://github.com/symfony/Filesystem
   * @license https://github.com/symfony/Filesystem/blob/master/LICENSE
   */
  public function isAbsolutePath($filepath) {
    if (strspn($filepath, '/\\', 0, 1)
      || (strlen($filepath) > 3 && ctype_alpha($filepath[0])
        && substr($filepath, 1, 1) === ':'
        && (strspn($filepath, '/\\', 2, 1))
      )
      || NULL !== parse_url($filepath, PHP_URL_SCHEME)
    ) {
      return TRUE;
    }

    return FALSE;
  }

  /**
   * Given an existing path, convert it to a path relative to a given starting
   * path.
   *
   * NOTE: This function is modified slightly from Symfony's method to strip
   * the trailing slash from files.
   *
   * @param string $end_path
   *   Absolute path of target
   * @param string $startPath
   *   Absolute path where traversal begins
   *
   * @return string
   *   Path of target relative to starting path
   *
   * @see https://github.com/symfony/Filesystem
   * @license https://github.com/symfony/Filesystem/blob/master/LICENSE
   */
  public function makePathRelative($end_path, $start_path) {

    // Normalize separators on Windows
    if (defined('PHP_WINDOWS_VERSION_MAJOR')) {
      $end_path = strtr($end_path, '\\', '/');
      $start_path = strtr($start_path, '\\', '/');
    }

    // Split the paths into arrays
    $start_path_arr = explode('/', trim($start_path, '/'));
    $end_path_arr = explode('/', trim($end_path, '/'));

    // Find for which directory the common path stops
    $index = 0;
    while (isset($start_path_arr[$index]) && isset($end_path_arr[$index]) && $start_path_arr[$index] === $end_path_arr[$index]) {
      $index++;
    }

    // Determine how deep the start path is relative to the common path (ie, "web/bundles" = 2 levels)
    $depth = count($start_path_arr) - $index;

    // Repeated "../" for each level need to reach the common path
    $traverser = str_repeat('../', $depth);

    $end_path_remainder = implode('/', array_slice($end_path_arr, $index));

    // Construct $end_path from traversing to the common path, then to the remaining $end_path
    $relative_path = $traverser.(strlen($end_path_remainder) > 0 ? $end_path_remainder.'/' : '');

    $relative_path = (strlen($relative_path) === 0) ? './' : $relative_path;
    return (is_file($end_path) || pathinfo($end_path, PATHINFO_EXTENSION) == 'php') ? rtrim($relative_path, '/') : $relative_path;
  }

  /**
   * Ensures the directory is created and protected via an .htaccess file if
   * is created in a public directory.
   *
   * @param string $directory
   *   The URI or path to the directory being prepared.
   *
   * @return bool
   */
  public function prepareDirectory($directory) {
    if (!file_prepare_directory($directory, FILE_CREATE_DIRECTORY)) {
      return FALSE;
    }
    if (strpos($directory, 'public://') === 0) {
      file_save_htaccess($directory, TRUE);
    }
    return TRUE;
  }

}
