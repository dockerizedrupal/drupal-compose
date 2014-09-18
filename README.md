dev
===

Install
-------

    TMP="$(mktemp -d)" \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" \
      && "${TMP}/dev.sh" install

Build the image
---------------

    sudo docker build \
      -t simpledrupalcloud/dev \
      http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git

Start dev
---------

    CONTAINER=dev && sudo docker run \
      --name "${CONTAINER}" \
      -h "${CONTAINER}" \
      -p 80:80 \
      -p 443:443 \
      -p 3306:3306 \
      -p 1080:1080 \
      -d \
      simpledrupalcloud/dev

Start Redis
-----------

    CONTAINER=redis && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -v /var/redis-2.8.14/data:/redis-2.8.14/data \
      -d \
      simpledrupalcloud/redis:2.8.14

Start Apache HTTP Server
------------------------

    CONTAINER=apache && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -v /var/apache-2.2.22/conf.d:/apache-2.2.22/conf.d \
      -v /var/apache-2.2.22/data:/apache-2.2.22/data \
      -v /var/apache-2.2.22/log:/apache-2.2.22/log \
      -e APACHE_SERVERNAME=example.com \
      -d \
      simpledrupalcloud/apache:2.2.22

Start PHP 5.6.0
---------------

    CONTAINER=php56 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.6.0

Start PHP 5.5.17
----------------

    CONTAINER=php55 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.5.17

Start PHP 5.4.31
----------------

    CONTAINER=php54 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.4.31

Start PHP 5.2.17
----------------

    CONTAINER=php52 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.2.17

Start PHP 5.3.28
----------------

    CONTAINER=php53 && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.3.28

Start MySQL
-----------

    CONTAINER=mysql && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -v /var/mysql-5.5.38/conf.d:/mysql-5.5.38/conf.d \
      -v /var/mysql-5.5.38/data:/mysql-5.5.38/data \
      -v /var/mysql-5.5.38/log:/mysql-5.5.38/log \
      -d \
      simpledrupalcloud/mysql:5.5.38

Start MailCatcher
-----------------

    CONTAINER=mailcatcher && sudo docker run \
      --name "${CONTAINER}" \
      --net container:dev \
      -d \
      simpledrupalcloud/mailcatcher:0.5.12
