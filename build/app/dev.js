#!/usr/bin/env node

var program = require('commander');
var YAML = require('yamljs');

program
  .command('up')
  .action(function(src) {
    process.stdout.write(YAML.load(src + '/dev.yaml').up);
  });

program
  .command('destroy')
  .action(function(src) {
    process.stdout.write(YAML.load(src + '/dev.yaml').destroy);
  });

program.parse(process.argv);
