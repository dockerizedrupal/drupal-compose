#!/usr/bin/env node

var program = require('commander');
var YAML = require('yamljs');

var config = YAML.load('/src/dev.yaml');

program
  .command('up')
  .action(function() {
    process.stdout.write(config.dev.up);
  });

program
  .command('destroy')
  .action(function() {
    process.stdout.write(config.dev.destroy);
  });

program.parse(process.argv);
