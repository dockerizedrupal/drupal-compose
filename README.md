# Drupal Compose

Generates general purpose [docker-compose.yml](https://docs.docker.com/compose/yml/) file automatically for your Drupal 6, 7 and 8 projects.

This project is part of the [Dockerized Drupal](https://dockerizedrupal.com/) initiative.

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
      && git checkout 1.1.4 \
      && sudo cp "${TMP}/drupal-compose.sh" /usr/local/bin/drupal-compose \
      && sudo chmod +x /usr/local/bin/drupal-compose \
      && cd -

## License

**MIT**
