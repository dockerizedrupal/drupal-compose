> **Notice:** *This project is part of the [Dockerized Drupal](https://dockerizedrupal.com/) initiative.*

# Drupal Compose

Generates general purpose [docker-compose.yml](https://docs.docker.com/compose/yml/) file automatically for your Drupal 6, 7 and 8 projects.

## Usage

    Usage: drupal-compose

    Options:
      -f, --file FILE   Specify an alternate compose file (default: docker-compose.yml)
      -v, --version     Show version number
      -h, --help        Show help

## Install

    TMP="$(mktemp -d)" \
      && git clone https://github.com/dockerizedrupal/drupal-compose.git "${TMP}" \
      && cd "${TMP}" \
      && git checkout 1.3.0 \
      && sudo cp "${TMP}/drupal-compose.sh" /usr/local/bin/drupal-compose \
      && sudo chmod +x /usr/local/bin/drupal-compose \
      && cd -

## Switching to a different PHP version

    drupal-compose service php set version <VERSION>

### Supported versions

    5.2
    5.3
    5.4
    5.5
    5.6

## License

**MIT**
