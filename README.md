# Drupal Compose

Generates general purpose [docker-compose.yml](https://docs.docker.com/compose/yml/) file automatically for your Drupal 6, 7 and 8 projects.

## Usage

    Usage: drupal-compose

    Options:
      -f, --file FILE   Specify an alternate compose file (default: docker-compose.yml)
      -v, --version     Show version number
      -h, --help        Show help

## Install / Update

    curl -sSL https://raw.githubusercontent.com/dockerizedrupal/drupal-compose/master/install.sh | sudo sh

## Switching to a different PHP version

    drupal-compose service php set version <VERSION>

### Supported versions

    5.2
    5.3
    5.4
    5.5
    5.6
    7.0

## License

**MIT**
