dev
===

Install
-------

    CONTEXT=$(mktemp -d) && sudo apt-get install -y git && git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT && $CONTEXT/dev.sh install

Init
----

    dev init

### Default dev.yaml file conetnt

    ---
    dev-master:
      user: root
      host: dev-master.simpledrupalcloud.com
      drupal_path: /var/www/arendus/project_1
    install: |
      #  install commands
    update: |
      # update commands
    start: |
      # start commands
    stop: |
      # stop commands

Start
-----

    dev start

Stop
----

    dev stop

Update
------

    dev update

Update and build the dependent images
-------------------------------------

    dev -b update

Remove
------

    dev remove