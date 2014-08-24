dev
===

Install
-------

    CONTEXT=$(mktemp -d) && sudo apt-get install -y git && git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT && $CONTEXT/dev.sh install

Init
----

    dev init

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