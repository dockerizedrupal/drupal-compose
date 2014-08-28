#!/usr/bin/env node

var fs   = require('fs');

var program = require('commander');
var Docker = require('dockerode');
var YAML = require('yamljs');
var dotty = require('dotty');

var socket = process.env.DOCKER_SOCKET || '/var/run/docker.sock';

if (!fs.statSync(socket).isSocket()) {
  throw new Error("Are you sure the docker is running?");
}

var config = YAML.load('./dev.yaml');

//console.log(config.services);

function in_array(value, array) {
  return array.indexOf(value) > -1;
}

function dependencies(services) {
  var resolved = [];

  (function resolve(service, resolved, seen) {
    seen.push(service);

    for (var dependency in services[service].requires) {
      dependency = services[service].requires[dependency];

      if (!in_array(dependency, resolved)) {
        if (in_array(dependency, seen)) {
          throw new Error('Circular reference detected: ' + service + ' -> ' + dependency);
        }

        resolve(dependency, resolved, seen);
      }
    }

    resolved.push(service);
  })('apache2', resolved, []);

  return resolved;
}

var docker = new Docker({
  socketPath: socket
});

docker.version(function(err, data) {

});

//docker.run('simpledrupalcloud/ssh', ['viljaste@arendus.fenomen.ee'], process.stdout, {
//  Tty: true,
//  Volumes: {
//    '/root/.ssh': {}
//  }
//}, {
//  Binds: [
//    '/home/viljaste/.ssh:/root/.ssh'
//  ]
//}, function(err, data, container) {
//  container.remove(function() {
//
//  });
//});

//program
//  .command('init')
//  .action(function() {
//    exec('cp /app/dev.yaml /src/dev.yaml', function(err, stdout, stderr) {
//      if (err) {
//        throw err;
//      }
//    });
//  });

program
  .command('up')
  .action(function() {
    var resolved = dependencies(config.services);

    for (var i in resolved) {
      var service = resolved[i];

      var data = config.services[service];

      var image = data.image;

      console.log(image);

      for (var j in data.instances) {
        var instance = data.instances[i];

        console.log(instance);

        docker.pull(image, function(err, stream) {
          if (err) {
            return err;
          }

          stream.pipe(process.stdout);
        });

//        docker.run(image, [], process.stdout, {
//          Tty: true,
//          name: service + instance
//        }, function(err, data, container) {
//          console.log(1);
//        });
      }
    }
  });

//program
//  .command('down')
//  .action(function() {
//    console.log(dotty.get(YAML.load('/src/dev.yaml'), 'dev.down'));
//  });
//
//program
//  .command('destroy')
//  .action(function() {
//    console.log(dotty.get(YAML.load('/src/dev.yaml'), 'dev.destroy'));
//  });
//
//program
//  .command('yaml')
//  .action(function(action, path) {
//    process.stdout.write(dotty[action](YAML.load('/src/dev.yaml'), path));
//  });

program.parse(process.argv);
