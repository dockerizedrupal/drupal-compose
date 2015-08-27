# Drupal Compose

Generates general purpose docker-compose.yml automatically for your Drupal 6, 7 and 8 projects.

## Usage

    Usage: drupal-compose
    
    Options:
      -f, --file FILE  Specify an alternate compose file (default: docker-compose.yml)
  
## Install

    TMP="$(mktemp -d)" \
      && git clone https://github.com/dockerizedrupal/crush.git "${TMP}" \
      && sudo cp "${TMP}/crush.sh" /usr/local/bin/crush \
      && sudo chmod +x /usr/local/bin/crush
      
## License

**MIT**
