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
    console.log(dotty.get(YAML.load('/src/dev.yaml'), 'dev.up'));
  });

program
  .command('down')
  .action(function() {
    console.log(dotty.get(YAML.load('/src/dev.yaml'), 'dev.down'));
  });

program
  .command('destroy')
  .action(function() {
    console.log(dotty.get(YAML.load('/src/dev.yaml'), 'dev.destroy'));
  });

program
  .command('yaml')
  .action(function(action, path) {
    process.stdout.write(dotty[action](YAML.load('/src/dev.yaml'), path));
  });

program.parse(process.argv);
