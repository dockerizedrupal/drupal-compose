dev
===

Install
-------

    TMP=$(mktemp -d) && sudo apt-get install -y git && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" && "${TMP}"/dev.sh install

Update the tool itself and all of the installed services
--------------------------------------------------------

    dev update

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

Configuration management
-------------------------

### Store

    dev config set [KEY] [VALUE]

### Retrive

    dev config get [KEY]