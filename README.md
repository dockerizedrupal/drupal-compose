dev
===

Install
-------

    CONTEXT=$(mktemp -d) && sudo apt-get install -y git && git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT && $CONTEXT/dev.sh install

Update
------

    dev update

Update and build the dependent images
-------------------------------------

    dev -b update

Remove
------

    dev remove