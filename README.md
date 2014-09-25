dev
===

Install
-------

    sudo docker run \
      --rm \
      -i \
      -t \
      -v /usr/local/bin:/usr/local/bin \
      simpledrupalcloud/dev \
      install

dev --help
----------


Stable commands:

    dev install
    dev update
    dev build
    dev start
    dev restart
    dev stop

    dev skydns attach
    dev skydns update
    dev skydns build
    dev skydns start
    dev skydns restart
    dev skydns stop
    dev skydns destroy

    dev skydock attach
    dev skydock update
    dev skydock build
    dev skydock start
    dev skydock restart
    dev skydock stop
    dev skydock destroy

    dev dev attach
    dev dev update
    dev dev build
    dev dev start
    dev dev restart
    dev dev stop
    dev dev destroy

    dev redis attach
    dev redis update
    dev redis build
    dev redis start
    dev redis restart
    dev redis stop
    dev redis destroy
    dev redis get <KEY]>
    dev redis set <KEY> <VALUE>

    dev apache attach
    dev apache update
    dev apache build
    dev apache start
    dev apache restart
    dev apache stop
    dev apache destroy

    dev mysql attach
    dev mysql update
    dev mysql build
    dev mysql start
    dev mysql restart
    dev mysql stop
    dev mysql destroy

    dev php56 enable
    dev php56 attach
    dev php56 update
    dev php56 build
    dev php56 start
    dev php56 restart
    dev php56 stop
    dev php56 destroy

    dev php55 enable
    dev php55 attach
    dev php55 update
    dev php55 build
    dev php55 start
    dev php55 restart
    dev php55 stop
    dev php55 destroy

    dev php54 enable
    dev php54 attach
    dev php54 update
    dev php54 build
    dev php54 start
    dev php54 restart
    dev php54 stop
    dev php54 destroy

    dev php53 enable
    dev php53 attach
    dev php53 update
    dev php53 build
    dev php53 start
    dev php53 restart
    dev php53 stop
    dev php53 destroy

    dev php52 enable
    dev php52 attach
    dev php52 update
    dev php52 build
    dev php52 start
    dev php52 restart
    dev php52 stop
    dev php52 destroy

    dev mailcatcher attach
    dev mailcatcher update
    dev mailcatcher build
    dev mailcatcher start
    dev mailcatcher restart
    dev mailcatcher stop
    dev mailcatcher destroy

    dev phpmyadmin install
    dev phpmyadmin update
    dev phpmyadmin destroy

Unstable or not implemented commands:

    dev status

    dev ports 80 127.0.0.1:3360

    dev php56 enable
    dev php55 enable
    dev php54 enable
    dev php53 enable
    dev php52 enable

    dev svn export [REPOSITORY] <REVISION_FROM:REVISION_TO> <TARGET>

    dev ssh <ENVIRONMENT> [PATH]
