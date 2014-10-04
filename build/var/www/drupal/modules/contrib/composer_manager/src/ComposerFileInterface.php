<?php

/**
 * @file
 * Contains \Drupal\composer_manager\ComposerManager.
 */

namespace Drupal\composer_manager;

interface ComposerFileInterface {

  /**
   * @return string
   */
  public function getFilepath();

  /**
   * Returns TRUE if the file exists and is a regular file.
   *
   * @return bool
   */
  public function exists();

  /**
   * Returns TRUE if the file exists and is valid JSON.
   *
   * @return bool
   */
  public function isValidJson();

  /**
   * Parses the contents of the Composer file into a PHP array.
   *
   * @return array
   *
   * @throws \RuntimeException
   */
  public function read();

  /**
   * Converts the data to a JSON string and writes the file.
   *
   * @param array $filedata
   *   The Composer filedata to encode.
   *
   * @return int
   *   This function returns the number of bytes that were written to the file.
   *
   * @throws \UnexpectedValueException
   * @throws \RuntimeException
   */
  public function write(array $filedata);

}
