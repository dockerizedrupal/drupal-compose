<?php

/**
 * @file
 * Contains \Drupal\composer_manager\ComposerPackages.
 */

namespace Drupal\composer_manager;

use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\Core\Lock\LockBackendInterface;

class ComposerPackages implements ComposerPackagesInterface {

  const REGEX_PACKAGE = '@^[A-Za-z0-9][A-Za-z0-9_.-]*/[A-Za-z0-9][A-Za-z0-9_.-]+$@';

  /**
   * @var \Drupal\Core\Lock\LockBackendInterface
   */
  protected $lock;

  /**
   * @var \Drupal\Core\Extension\ModuleHandlerInterface.
   */
  protected $moduleHandler;

  /**
   * @var \Drupal\composer_manager\FilesystemInterface
   */
  protected $filesystem;

  /**
   * @var \Drupal\composer_manager\ComposerManagerInterface
   */
  protected $manager;

  /**
   * The composer.lock file data parsed as a PHP array.
   *
   * @var array
   */
  private $composerLockFiledata;

  /**
   * The vendor/composer/installed.json file data parsed as a PHP array.
   *
   * @var array
   */
  private $installedJsonFiledata;

  /**
   * Whether the composer.json file was written during this request.
   *
   * @var bool
   */
  protected $composerJsonWritten = FALSE;

  /**
   * @param \Drupal\Core\Lock\LockBackendInterface $lock
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   * @param \Drupal\composer_manager\FilesystemInterface $filesystem
   * @param \Drupal\composer_manager\ComposerManagerInterface $manager
   */
  public function __construct(LockBackendInterface $lock, ModuleHandlerInterface $module_handler, FilesystemInterface $filesystem, ComposerManagerInterface $manager) {
    $this->lock = $lock;
    $this->moduleHandler = $module_handler;
    $this->filesystem = $filesystem;
    $this->manager = $manager;
  }

  /**
   * @return \Drupal\composer_manager\FilesystemInterface
   */
  public function getFilesystem() {
    return $this->filesystem;
  }

  /**
   * @return \Drupal\composer_manager\ComposerManagerInterface
   */
  public function getManager() {
    return $this->manager;
  }

  /**
   * Returns TRUE if the passed name is a valid Composer package name.
   *
   * @param string $package_name
   *
   * @return bool
   */
  public function isValidPackageName($package_name) {
    return preg_match(self::REGEX_PACKAGE, $package_name);
  }

  /**
   * Returns the composer.lock file data parsed as a PHP array.
   *
   * @return array
   */
  public function getComposerLockFiledata() {
    if (!isset($this->composerLockFiledata)) {
      $this->composerLockFiledata = $this->manager->readComposerLockFile();
    }
    return $this->composerLockFiledata;
  }

  /**
   * Returns the vendor/composer/installed.json file data parsed as a PHP array.
   *
   * @return array
   */
  public function getInstalledJsonFiledata() {
    if (!isset($this->installedJsonFiledata)) {
      $installed_json = new ComposerFile($this->manager->getVendorDirectory() . '/composer/installed.json');
      $this->installedJsonFiledata = $installed_json->exists() ? $installed_json->read() : array();
    }
    return $this->installedJsonFiledata;
  }

  /**
   * Reads installed package versions from the /vendor/ file.
   *
   * @return array
   *   An associative array of package version information.
   *
   * @throws \RuntimeException
   */
  public function getInstalled() {
    $packages = $this->manager->getCorePackages();

    $filedata = $this->getInstalledJsonFiledata();
    foreach ($filedata as $package) {
      $packages[$package['name']] = array(
        'version' => $package['version'],
        'description' => !empty($package['description']) ? $package['description'] : '',
        'homepage' => !empty($package['homepage']) ? $package['homepage'] : '',
      );
    }

    ksort($packages);
    return $packages;
  }

  /**
   * Returns the packages, versions, and the modules that require them in the
   * composer.json files contained in contributed modules.
   *
   * @return array
   */
  public function getRequired() {
    $packages = array();

    // Read the packages that are hardcoded in core.
    foreach ($this->manager->getCorePackages() as $package_name => $package) {
      $packages[$package_name][$package['version']] = array('drupal');
    }

    // Read requirements from every module's composer.json file.
    $files = $this->getComposerJsonFiles();
    foreach ($files as $module => $composer_json) {
      $filedata = $composer_json->read();
      $filedata += array('require' => array());
      foreach ($filedata['require'] as $package_name => $version) {
        if ($this->isValidPackageName($package_name)) {
          if (!isset($packages[$package_name])) {
            $packages[$package_name][$version] = array();
          }
          $packages[$package_name][$version][] = $module;
        }
      }
    }

    ksort($packages);
    return $packages;
  }

  /**
   * Returns each installed packages dependents.
   *
   * @return array
   *   An associative array of installed packages to their dependents.
   *
   * @throws \RuntimeException
   */
  public function getDependencies() {
    $packages = array();

    $filedata = $this->getInstalledJsonFiledata();
    foreach ($filedata as $package) {
      if (!empty($package['require'])) {
        foreach ($package['require'] as $dependent => $version) {
          $packages[$dependent][] = $package['name'];
        }
      }
    }

    return $packages;
  }

  /**
   * Returns a list of packages that need to be installed.
   *
   * @return array
   */
  public function getInstallRequired() {
    $packages = array();

    $required = $this->getRequired();
    $installed = $this->getInstalled();
    $combined = array_unique(array_merge(array_keys($required), array_keys($installed)));

    foreach ($combined as $package_name) {
      if (!isset($installed[$package_name])) {
        $packages[] = $package_name;
      }
    }

    return $packages;
  }

  /**
   * Writes the consolidated composer.json file for all modules that require
   * third-party packages managed by Composer.
   *
   * @param array $modules
   *   (Optional) Array of modules to include in addition to enabled modules.
   *
   * @return int
   *
   * @throws \RuntimeException
   */
  public function writeComposerJsonFile(array $modules = array()) {
    $bytes = $this->composerJsonWritten = FALSE;

    // Ensure only one process runs at a time. 10 seconds is more than enough.
    // It is rare that a conflict will happen, and it isn't mission critical
    // that we wait for the lock to release and regenerate the file again.
    if (!$this->lock->acquire(__FUNCTION__, 10)) {
      throw new \RuntimeException('Timeout waiting for lock');
    }

    try {
      $composer_json = $this->manager->getComposerJsonFile();
      $files = $this->getComposerJsonFiles($modules);

      $filedata = (array) $this->mergeComposerJsonFiles($files);
      $bytes = $composer_json->write($filedata);
      $this->composerJsonWritten = ($bytes !== FALSE);

      $this->lock->release(__FUNCTION__);
    }
    catch (\RuntimeException $e) {
      $this->lock->release(__FUNCTION__);
      throw $e;
    }

    return $bytes;
  }

  /**
   * Returns TRUE if the composer.json file was written in this request.
   *
   * @return bool
   *
   * @throws \RuntimeException
   */
  public function composerJsonFileWritten() {
    return $this->composerJsonWritten;
  }

  /**
   * Fetches the data in each module's composer.json file.
   *
   * @param array $modules
   *   (Optional) Array of modules in addition to enabled modules.
   *
   * @return \Drupal\composer_manager\ComposerFileInterface[]
   *
   * @throws \RuntimeException
   */
  function getComposerJsonFiles($modules = array()) {
    $files = array();

    $module_list = $this->moduleHandler->getModuleList();

    // Add listed modules to the enabled module list. It is not necessary to
    // add \Drupal\Core\Extension\Extension as the array value as it is not
    // necessary for composer.json.
    if (!empty($modules)) {
      foreach ($modules as $module_name) {
        if (!isset($module_list[$module_name]) &&
            drupal_get_path('module', $module_name)) {
          $module_list[$module_name] = $module_name;
        }
      }
    }

    foreach ($module_list as $module_name => $filename) {
      $filepath = drupal_get_path('module', $module_name) . '/composer.json';
      $composer_json = new ComposerFile($filepath);
      if ($composer_json->exists()) {
        $files[$module_name] = $composer_json;
      }
    }
    return $files;
  }

  /**
   * Builds the JSON array containing the combined requirements of each module's
   * composer.json file.
   *
   * @param \Drupal\composer_manager\ComposerFileInterface[] $filedata
   *   An array composer.json file objects keyed by module.
   *
   * @return \Drupal\composer_manager\ComposerJsonMerger
   *
   * @throws \RuntimeException
   */
  public function mergeComposerJsonFiles(array $files) {

    // Merges the composer.json files.
    $merged = new ComposerJsonMerger($this);
    foreach ($files as $module => $composer_json) {
      $merged
        ->mergeProperty($composer_json, 'require')
        ->mergeProperty($composer_json, 'require-dev')
        ->mergeProperty($composer_json, 'conflict')
        ->mergeProperty($composer_json, 'replace')
        ->mergeProperty($composer_json, 'provide')
        ->mergeProperty($composer_json, 'suggest')
        ->mergeProperty($composer_json, 'repositories')
        ->mergeAutoload($composer_json, 'psr-0', $module)
        ->mergeAutoload($composer_json, 'psr-4', $module)
        ->mergeAutoload($composer_json, 'classmap', $module)
        ->mergeAutoload($composer_json, 'files', $module)
        ->mergeMinimumStability($composer_json)
      ;
    }

    // Replace all core packages if we are installing to a different vendor dir.
    if ($this->manager->getVendorDirectory() != DRUPAL_ROOT . '/core/vendor') {

      // Replace packages included in Drupal core.
      if (!isset($merged['replace'])) {
        $merged['replace'] = array();
      }

      $packages = $this->manager->getCorePackages();
      foreach ($packages as $package_name => $package) {
        $merged['replace'][$package_name] = $package['version'];
      }

      // The symfony/translation package included in core is not the full
      // release and only contains the TranslatorInterface interface, so we have
      // to include the whole package, i.e. not replace it in the consolidated
      // composer.json file even though Composer thinks it is installed.
      // @see https://drupal.org/node/2212171
      // @see https://drupal.org/comment/8555145#comment-8555145
      $replace = &$merged['replace'];
      unset($replace['symfony/translation']);

      // Replacing dev-master versions can cause dependency issues.
      if (strpos($merged['replace']['doctrine/annotations'], 'dev-master') === 0) {
        $merged['replace']['doctrine/annotations'] = '>=1.1.2';
      }
      if (strpos($merged['replace']['doctrine/common'], 'dev-master') === 0) {
        $merged['replace']['doctrine/common'] = '>=2.4.1';
      }
      if (strpos($merged['replace']['phpunit/phpunit-mock-objects'], 'dev-master') === 0) {
        $merged['replace']['phpunit/phpunit-mock-objects'] = '>=2.1.5';
      }
      if (strpos($merged['replace']['symfony/yaml'], 'dev-master') === 0) {
        $merged['replace']['symfony/yaml'] = '>=2.4.1';
      }
    }

    $this->moduleHandler->alter('composer_json', $merged);
    return $merged;
  }

  /**
   * Returns TRUE if at least one passed modules has a composer.json file or
   * implements hook_composer_json_alter(). These conditions indicate that the
   * consolidated composer.json file has likely changed.
   *
   * @param array $modules
   *   The list of modules being scanned for composer.json files, usually a list
   *   of modules that were installed or uninstalled.
   *
   * @return bool
   */
  public function haveChanges(array $modules) {
    foreach ($modules as $module) {

      // Check if the module has a composer.json file.
      $filepath = drupal_get_path('module', $module) . '/composer.json';
      $composer_json = new ComposerFile($filepath);
      if ($composer_json->exists()) {
        return TRUE;
      }

      // Check if the module implements hook_composer_json_alter().
      if ($this->moduleHandler->implementsHook($module, 'composer_json_alter')) {
        return TRUE;
      }

    }
    return FALSE;
  }
}
