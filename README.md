dev
===

Install
-------

    CONTEXT=$(mktemp -d) && sudo apt-get install -y git && git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT && $CONTEXT/dev.sh install

Usage
-----

### dev init

Creates a simple YAML file (dev.yaml) into the working directory if it doesn't already exist.

### dev up

Runs commands defined

### dev down

### dev destroy

### dev ssh master