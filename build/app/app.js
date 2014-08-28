#!/usr/bin/env node

var exec = require('child_process').exec;

var program = require('commander');
var YAML = require('yamljs');
var jsonQuery = require('json-query');

program
  .command('init')
  .action(function() {
    exec('cp /app/dev.yaml /src/dev.yaml', function(err, stdout, stderr) {
      if (err) {
        throw err;
      }
    });
  });

program
  .command('up')
  .action(function() {
    process.stdout.write(jsonQuery('up', {
      data: YAML.load('/src/dev.yaml')
    }).value);
  });

program.parse(process.argv);
