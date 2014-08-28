#!/usr/bin/env node

var exec = require('child_process').exec;

var program = require('commander');
var YAML = require('yamljs');
var dotty = require('dotty');

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
    process.stdout.write(dotty.get(YAML.load('/src/dev.yaml'), 'dev.up'));
  });

program.parse(process.argv);
