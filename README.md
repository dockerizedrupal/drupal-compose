dev
===

Build the image
---------------

    sudo docker build \
      -t simpledrupalcloud/dev \
      http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git

Run dev
-------

    CONTAINER=dev && sudo docker run \
      --name "${CONTAINER}" \
      -h "${CONTAINER}" \
      -p 80:80 \
      -d \
      simpledrupalcloud/dev

Run Redis
---------

    CONTAINER=redis2814 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -v /var/redis-2.8.14/data:/redis-2.8.14/data \
      -d \
      simpledrupalcloud/redis:2.8.14

Run Apache HTTP Server
----------------------

    CONTAINER=apache && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -v /var/apache-2.2.22/conf.d:/apache-2.2.22/conf.d \
      -v /var/apache-2.2.22/data:/apache-2.2.22/data \
      -v /var/apache-2.2.22/log:/apache-2.2.22/log \
      -e APACHE_SERVERNAME=example.com \
      -d \
      simpledrupalcloud/apache:2.2.22

Run PHP 5.5.15
--------------

    CONTAINER=php5515 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.5.15

Run MySQL
---------

    CONTAINER=mysql && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -v /var/mysql-5.5.38/conf.d:/mysql-5.5.38/conf.d \
      -v /var/mysql-5.5.38/data:/mysql-5.5.38/data \
      -v /var/mysql-5.5.38/log:/mysql-5.5.38/log \
      -d \
      simpledrupalcloud/mysql:5.5.38

Run MailCatcher
---------------

    CONTAINER=mailcatcher && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -d \
      simpledrupalcloud/mailcatcher:0.5.12

Install
-------

    TMP=$(mktemp -d) \
      && sudo apt-get install -y git \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" \
      && "${TMP}/dev.sh" install

Update the tool itself and all of the installed services
--------------------------------------------------------

    dev update

Containers
----------

### MailCatcher

### Apache HTTP server

### PHP

### MySQL

Service management
------------------

### Start all services

    dev start

### Restart all running services

    dev restart

#### Restart individual services

    dev restart [SERVICE NAME]

##### Installed services

  - redis 2.8.14
  - mailcatcher 0.5.12
  - apache 2.2.22
  - php 5.2.17
  - php 5.3.28
  - php 5.4.31
  - php 5.5.15
  - mysql 5.5.38

### Destroy all services

    dev destroy

Services
--------

### Configuration management

Configuration management is backed by Redis data store container

#### Containers

##### Redis

Redis data store is used internally by `dev` to store environment specific configuration variables

#### Store

    dev config set [KEY] [VALUE]

#### Retrive

    dev config get [KEY]

Debugging
---------

Commands that are used internally by `dev` and shouldn't be called directly

### Download or update a Docker image

    dev image [IMAGE] pull

### Destroy a Docker image and all the containers that are an instance of it

    dev image [IMAGE] destroy

### Destroy a Docker container

    dev container [CONTAINER] destroy

    dev dev config get [KEY]
    dev dev config set [KEY] [VALUE]