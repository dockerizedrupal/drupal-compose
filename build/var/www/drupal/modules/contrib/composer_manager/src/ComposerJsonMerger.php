<?php

namespace Drupal\composer_manager;

class ComposerJsonMerger extends \ArrayObject {

  /**
   * Maps stability strings to numbers, the higher the number the more stable.
   *
   * @var array
   */
  protected $stability = array(
    'dev' => 0,
    'alpha' => 1,
    'beta' => 2,
    'RC' => 3,
    'rc' => 3,
    'stable' => 4,
  );

  /**
   * @var \Drupal\composer_manager\ComposerPackagesInterface
   */
  protected $packages;

  /**
   * @var string
   */
  protected $endPath;

  /**
   * @param \Drupal\composer_manager\ComposerPackagesInterface $packages
   */
  public function __construct(ComposerPackagesInterface $packages) {
    $this->packages = $packages;
    $data = array('config' => array());

    // Make absolutely sure that the core autoload.php file is sourced. This is
    // mostly required for running executables that are linked to in a module's
    // requirements. In the context of Drupal it is not a problem that this file
    // is sourced twice as Composer is smart enough to register the autoloader
    // only once.
    // @see https://drupal.org/node/2212171
    $data['autoload']['files'] = array($this->getRelativeDrupalRootDirectory() . 'core/vendor/autoload.php');

    // Calculates the relative path the the configured vendor directory.
    $vendor_dir = $this->getRelativeVendorDirectory();
    if (0 !== strlen($vendor_dir) && 'vendor' != $vendor_dir) {
      $data['config']['vendor-dir'] = $vendor_dir;
    }

    $data['config'] += array(
      'autoloader-suffix' => 'ComposerManager',
    );

    // Stores the composer file directory for the relative autoload path
    // calculation.
    $this->endPath = $this->packages->getManager()->getComposerFileDirectory();

    parent::__construct($data);
  }

  /**
   * Returns the relative path to DRUPAL_ROOT directory.
   *
   * @return string
   *
   * @throws \RuntimeException
   */
  public function getRelativeDrupalRootDirectory() {
    $manager = $this->packages->getManager();
    return $this->packages->getFilesystem()->makePathRelative(
      DRUPAL_ROOT,
      $manager->getComposerFileDirectory()
    );
  }

  /**
   * Returns the relative path to the vendor directory.
   *
   * @return string
   *
   * @throws \RuntimeException
   */
  public function getRelativeVendorDirectory() {
    $manager = $this->packages->getManager();
    return $this->packages->getFilesystem()->makePathRelative(
      $manager->getVendorDirectory(),
      $manager->getComposerFileDirectory()
    );
  }

  /**
   * Useful as an array_walk() callback that calculates the relative autoload
   * path given the passed module.
   *
   * @param string &$path
   * @param int $key
   * @param string $module
   */
  public function getRelativeAutoloadPath(&$path, $key, $module) {
    $start_path = DRUPAL_ROOT . '/' . drupal_get_path('module', $module) . '/' . $path;
    $path = $this->packages->getFilesystem()->makePathRelative($start_path, $this->endPath);
  }

  /**
   * Compares the passed minimum stability requirements.
   *
   * @param string $stability_a
   * @param string $stability_b
   *
   * @return int
   *   Returns -1 if the first version is lower than the second, 0 if they are
   *   equal, and 1 if the second is lower.
   *
   * @throws \UnexpectedValueException
   */
  public function compareStability($stability_a, $stability_b) {
    if (!isset($this->stability[$stability_a]) || !isset($this->stability[$stability_b])) {
      throw new \UnexpectedValueException('Unexpected stability');
    }

    if ($this->stability[$stability_a] == $this->stability[$stability_b]) {
      return 0;
    }
    else {
      return $this->stability[$stability_a] < $this->stability[$stability_b] ? -1 : 1;
    }
  }

  /**
   * Extracts a property from the composer.json file.
   *
   * @param \Drupal\composer_manager\ComposerFileInterface $composer_json
   * @param string|array $property
   *
   * @return mixed
   */
  public function getPropertyValue(ComposerFileInterface $composer_json, $property) {
    return $this->getNestedPropertyValue($composer_json->read(), (array) $property);
  }

  /**
   * Recursive function to extract a nested property from an array.
   *
   * @param mixed $data
   * @param array $property
   *
   * @return mixed
   */
  public function getNestedPropertyValue($data, array $property) {
    if ($property) {
      $key = array_shift($property);
      return isset($data[$key]) ? $this->getNestedPropertyValue($data[$key], $property) : NULL;
    }
    else {
      return $data;
    }
  }

  /**
   * Merges a top-level property.
   *
   * @param \Drupal\composer_manager\ComposerFileInterface $composer_json
   * @param string $property
   *
   * @return \Drupal\composer_manager\ComposerJsonMerger
   */
  public function mergeProperty(ComposerFileInterface $composer_json, $property) {
    $value = $this->getPropertyValue($composer_json, $property);

    $filedata = $composer_json->read();
    if (isset($filedata[$property])) {
      if (isset($this[$property]) && is_array($this[$property])) {
        $this[$property] = array_merge($this[$property], $filedata[$property]);
      }
      else {
        $this[$property] = $filedata[$property];
      }
    }

    return $this;
  }

  /**
   * Merges autoload properties.
   *
   * @param \Drupal\composer_manager\ComposerFileInterface $composer_json
   * @param string $property
   * @param string $module
   *
   * @return \Drupal\composer_manager\ComposerJsonMerger
   */
  public function mergeAutoload(ComposerFileInterface $composer_json, $property, $module) {
    $values = (array) $this->getPropertyValue($composer_json, array('autoload', $property));
    foreach ($values as $namesapce => $dirs) {

      // Make the autoload paths relative to the module that the composer.json
      // file is defined in.
      $dirs = (array) $dirs;
      array_walk($dirs, array($this, 'getRelativeAutoloadPath'), $module);

      // Initialize the autoload prioerty.
      if (!isset($this['autoload'][$property])) {
        $this['autoload'][$property] = array();
      }

      // Merge strategy is dirrerent for psr-0, psr-4 properties than files,
      // classpath properties. If the namspace variable is not an integer then
      // assume psr-0 or psr-4.
      if (!is_int($namesapce)) {
        $this['autoload'][$property] += array($namesapce => array());
        $this['autoload'][$property][$namesapce] = array_merge($this['autoload'][$property][$namesapce], $dirs);
      }
      else {
        $this['autoload'][$property] = array_merge($this['autoload'][$property], $dirs);
      }
    }

    return $this;
  }

  /**
   * @param \Drupal\composer_manager\ComposerFileInterface $composer_json
   *
   * @return \Drupal\composer_manager\ComposerJsonMerger
   */
  public function mergeMinimumStability(ComposerFileInterface $composer_json) {
    $filedata = $composer_json->read();
    if (isset($filedata['minimum-stability'])) {
      if (!isset($this['minimum-stability']) || -1 == $this->compareStability($filedata['minimum-stability'], $this['minimum-stability'])) {
        $this['minimum-stability'] = $filedata['minimum-stability'];
      }
    }
    return $this;
  }
}
