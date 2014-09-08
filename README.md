dev
===

Install
-------

    TMP=$(mktemp -d) && sudo apt-get install -y git && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" && "${TMP}"/dev.sh install

Update services
---------------

    dev update

Start services
--------------

    dev start

Restart services
----------------

    dev restart

Destroy services
----------------

    dev destroy