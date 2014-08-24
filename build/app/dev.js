#!/usr/bin/env node

var program = require('commander');
var YAML = require('yamljs');

program
  .command('up')
  .action(function(context) {
    process.stdout.write(YAML.load(context + '/dev.yaml').up);
  });

program
  .command('destroy')
  .action(function(context) {
    process.stdout.write(YAML.load(context + '/dev.yaml').destroy);
  });

program.parse(process.argv);
