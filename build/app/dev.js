#!/usr/bin/env node

var program = require('commander');
var YAML = require('yamljs');
var jsonQuery = require('json-query');

program
  .command('yaml')
  .action(function(query) {
    process.stdout.write(jsonQuery(query, {
      data: YAML.load('/src/dev.yaml')
    }).value);
  });

program.parse(process.argv);
