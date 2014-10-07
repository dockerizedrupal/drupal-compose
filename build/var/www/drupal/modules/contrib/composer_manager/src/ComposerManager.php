<?php

/**
 * @file
 * Contains \Drupal\composer_manager\ComposerManager.
 */

namespace Drupal\composer_manager;

use Drupal\Component\Utility\String;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Extension\ModuleHandlerInterface;

/**
 * Gets configuration settings and installed / required packages.
 */
class ComposerManager implements ComposerManagerInterface {

  /**
   * The composer_manager.settings config object.
   *
   * @var \Drupal\Core\Config\Config
   */
  protected $config;

  /**
   * @var \Drupal\Core\Extension\ModuleHandlerInterface.
   */
  protected $moduleHandler;

  /**
   * @var \Drupal\composer_manager\FilesystemInterface
   */
  protected $filesystem;

  /**
   * @var bool
   */
  protected $autoloaderRegistered = false;

  /**
   * @var array
   */
  private $corePackages = array();

  /**
   * Constructs a \Drupal\composer_manager\ComposerManager object.
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   * @param \Drupal\composer_manager\FilesystemInterface $filesystem
   */
  public function __construct(ConfigFactoryInterface $config_factory, ModuleHandlerInterface $module_handler, FilesystemInterface $filesystem) {
    $this->config = $config_factory->get('composer_manager.settings');
    $this->moduleHandler = $module_handler;
    $this->filesystem = $filesystem;
  }

  /**
   * Prepares and returns the realpath to the Composer file directory.
   *
   * @return string
   *
   * @throws \RuntimeException
   */
  public function getComposerFileDirectory() {
    $directory = $this->config->get('file_dir');
    if (!$this->filesystem->prepareDirectory($directory)) {
      throw new \RuntimeException(String::format('Error creating directory: @directory', array('@directory' => $directory)));
    }
    if (!$realpath = drupal_realpath($directory)) {
      throw new \RuntimeException(String::format('Error resolving directory: @directory', array('@directory' => $directory)));
    }
    return $realpath;
  }

  /**
   * Returns the consolidated composer.json file.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface
   */
  public function getComposerJsonFile() {
    return new ComposerFile($this->config->get('file_dir') . '/composer.json');
  }

  /**
   * Returns the consolidated composer.lock file.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface
   */
  public function getComposerLockFile() {
    return new ComposerFile($this->config->get('file_dir') . '/composer.lock');
  }

  /**
   * Reads the consolidated composer.lock file and parses in to a PHP array.
   *
   * @return array
   *
   * @throws \RuntimeException
   */
  public function readComposerLockFile() {
    $lock_file = $this->getComposerLockFile();
    $filedata = $lock_file->exists() ? $lock_file->read() : array();
    return $filedata + array('packages' => array());
  }

  /**
   * Returns the absolute path to the vendor directory.
   *
   * @return string
   */
  public function getVendorDirectory() {
    $directory = $this->config->get('vendor_dir');
    if (!$this->filesystem->isAbsolutePath($directory)) {
      $directory = DRUPAL_ROOT . '/' . $directory;
    }
    return $directory;
  }

  /**
   * Returns the absolute path to the autoload.php file.
   *
   * @return string
   */
  public function getAutoloadFilepath() {
    return $this->getVendorDirectory() . '/autoload.php';
  }

  /**
   * Returns an associative array of packages included in core to version.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface
   */
  public function getCorePackages() {
    if (!$this->corePackages) {

      $composer_lock = new ComposerFile(DRUPAL_ROOT . '/core/vendor/composer/installed.json');
      $filedata = $composer_lock->read();

      foreach ($filedata as $package) {
        $this->corePackages[$package['name']] = array(
          'version' => $package['version'],
          'description' => !empty($package['description']) ? $package['description'] : '',
          'homepage' => !empty($package['homepage']) ? $package['homepage'] : '',
        );
        if ('dev-master' == $package['version']) {
          $this->corePackages[$package['name']]['version'] .= '#' . $package['source']['reference'];
        }
      }

      ksort($this->corePackages);
    }

    return $this->corePackages;
  }

  /**
   * Returns TRUE if the Composer Manager module is configured to automatically
   * build the consolidated composer.json file or Drupal is being run via the
   * command line (Drush assumed).
   *
   * @return bool
   */
  public function autobuildComposerJsonFile() {
    return (PHP_SAPI === 'cli') || $this->config->get('autobuild_file');
  }

  /**
   * Registers the autoloader.
   *
   * @throws \RuntimeException
   */
  public function registerAutoloader() {
    if (!$this->autoloaderRegistered) {

      $filepath = $this->getAutoloadFilepath();
      if (!is_file($filepath)) {
        throw new \RuntimeException(String::format('Autoloader not found: @filepath', array('@filepath' => $filepath)));
      }

      $this->autoloaderRegistered = TRUE;
      if ($filepath != DRUPAL_ROOT . '/core/vendor/autoload.php') {
        require $filepath;
      }
    }
  }
}
