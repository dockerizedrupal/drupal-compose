dev
===

Install
-------

    TMP=$(mktemp -d) && sudo apt-get install -y git && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" && "${TMP}"/dev.sh install

Usage
-----

### dev init

### dev up

### dev destroy

### dev ssh

#### dev ssh [ENVIRONMENT]

#### dev ssh *

### dev sync files [ENVIRONMENT_FROM] [ENVIRONMENT_TO]

### dev sync database [ENVIRONMENT_FROM] [ENVIRONMENT_TO]

### dev git

### dev svn

### dev user

#### dev user [USER] password

### dev snippet

#### dev snippet add [SNIPPET_NAME] < snippet.js

#### dev snippet delete [SNIPPET_NAME]

#### dev snippet [SNIPPET_NAME] [USER]