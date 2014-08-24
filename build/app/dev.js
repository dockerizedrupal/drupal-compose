#!/usr/bin/env node

var fs = require('fs');
var program = require('commander');
var YAML = require('yamljs');

program
  .command('start')
  .action(function(context) {
    yaml = YAML.load(context + '/dev.yaml');

    process.stdout.write(yaml.start);
  });

program.parse(process.argv);
