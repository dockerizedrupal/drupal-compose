#!/usr/bin/env node

var program = require('commander');
var YAML = require('yamljs');
var dotty = require("dotty");

program
  .command('yaml')
  .action(function(path) {
    process.stdout.write(dotty.get(YAML.load('/src/dev.yaml'), path));
  });

program.parse(process.argv);
