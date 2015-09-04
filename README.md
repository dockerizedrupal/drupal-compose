# Drupal Compose

Generates general purpose [docker-compose.yml](https://docs.docker.com/compose/yml/) automatically for your Drupal 6, 7 and 8 projects.

## Usage

    Usage: drupal-compose
    
    Options:
      -f, --file FILE  Specify an alternate compose file (default: docker-compose.yml)
  
## Install

    TMP="$(mktemp -d)" \
      && git clone https://github.com/dockerizedrupal/drupal-compose.git "${TMP}" \
      && cd "${TMP}" \
      && git checkout 1.0.5 \
      && sudo cp "${TMP}/drupal-compose.sh" /usr/local/bin/drupal-compose \
      && sudo chmod +x /usr/local/bin/drupal-compose \
      && cd -

## License

**MIT**
