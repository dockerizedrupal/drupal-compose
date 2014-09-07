dev
===

    TMP=$(mktemp -d) && sudo apt-get install -y git && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" && "${TMP}"/dev.sh install