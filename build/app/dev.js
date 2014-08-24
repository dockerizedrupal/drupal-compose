#!/usr/bin/env node

var fs = require('fs');
var program = require('commander');

program
  .command('init')
  .action(function(context) {
    fs.createReadStream('/app/dev.yaml').pipe(fs.createWriteStream(context + '/dev.yaml'));
  });

program.parse(process.argv);
