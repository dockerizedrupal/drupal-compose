<?php

namespace Drupal\dev\Controller;

use Drupal\Core\Controller\ControllerBase;

use \Michelf\Markdown;

class ReadmeController extends ControllerBase {
  public function readme() {
    $url = 'https://raw.githubusercontent.com/simpledrupalcloud/dev/master/README.md';

    try {
      $readme = \Drupal::httpClient()->get($url)->getBody(TRUE);

      return array(
        '#markup' => Markdown::defaultTransform($readme),
      );
    }
    catch (BadResponseException $exception) {
      $response = $exception->getResponse();

      drupal_set_message(t('Failed to fetch file due to HTTP error "%error"', array('%error' => $response->getStatusCode() . ' ' . $response->getReasonPhrase())), 'error');

      return FALSE;
    }
    catch (RequestException $exception) {
      drupal_set_message(t('Failed to fetch file due to error "%error"', array('%error' => $exception->getMessage())), 'error');

      return FALSE;
    }
  }
}
