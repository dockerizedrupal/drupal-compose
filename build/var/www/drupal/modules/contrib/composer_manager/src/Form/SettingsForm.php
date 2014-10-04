<?php

/**
 * @file
 * Contains \Drupal\composer_manager\Form\SettingsForm.
 */

namespace Drupal\composer_manager\Form;

use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Drupal\Core\Form\FormInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Form\ConfigFormBase;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\composer_manager\FilesystemInterface;

/**
 * Provides administrative settings for the Composer Manager module.
 *
 * @ingroup forms
 */
class SettingsForm extends ConfigFormBase implements FormInterface, ContainerInjectionInterface {

  /**
   * @var \Drupal\Core\Extension\ModuleHandlerInterface
   */
  protected $moduleHandler;

  /**
   * @var \Drupal\composer_manager\FilesystemInterface
   */
  protected $filesystem;

  /**
   * Constructs a \Drupal\composer_manager\SettingsForm object.
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   * @param \Drupal\composer_manager\FilesystemInterface $filesystem
   */
  public function __construct(ConfigFactoryInterface $config_factory, ModuleHandlerInterface $module_handler, FilesystemInterface $filesystem) {
    parent::__construct($config_factory);
    $this->moduleHandler = $module_handler;
    $this->filesystem = $filesystem;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('config.factory'),
      $container->get('module_handler'),
      $container->get('composer_manager.filesystem')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getFormID() {
    return 'composer_manager_settings';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $form = parent::buildForm($form, $form_state);

    $config = $this->config('composer_manager.settings');
    $form['composer_manager_vendor_dir'] = array(
      '#title' => 'Vendor Directory',
      '#type' => 'textfield',
      '#default_value' => $config->get('vendor_dir'),
      '#description' => t('The relative or absolute path to the vendor directory containing the Composer packages and autoload.php file.'),
    );

    $form['composer_manager_file_dir'] = array(
      '#title' => 'Composer File Directory',
      '#type' => 'textfield',
      '#default_value' => $config->get('file_dir'),
      '#description' => t('The directory containing the composer.json file and where Composer commands are run.'),
    );

    $form['composer_manager_autobuild_file'] = array(
      '#title' => 'Automatically build the composer.json file when enabling or disabling modules in the Drupal UI',
      '#type' => 'checkbox',
      '#default_value' => $config->get('autobuild_file'),
      '#description' => t('Automatically build the consolidated composer.json for all contributed modules file in the vendor directory above when modules are enabled or disabled in the Drupal UI. Disable this setting if you want to maintain the composer.json file manually.'),
    );

    $form['composer_manager_autobuild_packages'] = array(
      '#title' => 'Automatically update Composer dependencies when enabling or disabling modules with Drush',
      '#type' => 'checkbox',
      '#default_value' => $config->get('autobuild_packages'),
      '#description' => t('Automatically build the consolidated composer.json file and run Composer\'s <code>!command</code> command when enabling or disabling modules with Drush. Disable this setting to manage the composer.json and dependencies manually.', array('!command' => 'update')),
    );

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    parent::validateForm($form, $form_state);
    $form_state_values = $form_state->getValues();

    $this->moduleHandler->loadInclude('composer_manager', 'inc', 'composer_manager.writer');

    $autobuild_file = $form_state_values['composer_manager_autobuild_file'];
    $file_dir = $form_state_values['composer_manager_file_dir'];
    if ($autobuild_file && !$this->filesystem->prepareDirectory($file_dir)) {
      $form_state->setErrorByName('composer_manager_file_dir', t('Composer file directory must be writable'));
    }
  }

  public function submitForm(array &$form, FormStateInterface $form_state) {
    parent::submitForm($form, $form_state);
    $form_state_values = $form_state->getValues();
    $this->config('composer_manager.settings')
      ->set('vendor_dir', $form_state_values['composer_manager_vendor_dir'])
      ->set('file_dir', $form_state_values['composer_manager_file_dir'])
      ->set('autobuild_file', $form_state_values['composer_manager_autobuild_file'])
      ->set('autobuild_packages', $form_state_values['composer_manager_autobuild_packages'])
    ->save();
  }

}
