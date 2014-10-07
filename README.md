# dev

The most easy to use development tool to develop Drupal projects

## Install

    sudo docker run \
      --rm \
      -i \
      -t \
      -v /usr/local/bin:/usr/local/bin \
      simpledrupalcloud/dev:latest \
      install

## Start

    CONTAINER="dev" && sudo docker run \
      --name "${CONTAINER}" \
      -h "${CONTAINER}" \
      -p 80:80 \
      -d \
      simpledrupalcloud/dev:latest
