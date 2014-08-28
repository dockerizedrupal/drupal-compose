#!/usr/bin/env node

var program = require('commander');
//var YAML = require('yamljs');
//var jsonQuery = require('json-query');

program
  .command('init')
  .action(function() {
    exec('cp /app/dev.yaml /src/dev.yaml', function(err, stdout, stderr) {
      if (err) {
        throw err;
      }
    });
  });

program.parse(process.argv);
