dev
===

Build the image yourself
------------------------



Install
-------

    CONTEXT=$(mktemp -d) && sudo apt-get install -y git && git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT && $CONTEXT/dev.sh install

Usage
-----

### dev init

Creates a simple YAML file (dev.yaml) into the working directory if it doesn't already exist.

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

### dev