#!/usr/bin/env node

var program = require('commander');

var Config = require('./config.js');

//var through2 = require('through2');

//var Configuration = require('./configuration.js');
//var Docker = require('./docker.js');

//var configuration = new Configuration('./dev.yaml');
//
//configuration.service('apache').dependencies.resolve();
//
//configuration.services();

//var docker = new Docker('/var/run/docker.sock');
//
//docker.run('simpledrupalcloud/ssh', {}, function() {
//
//});

//var up = function() {
//
//};

//var socket = process.env.DOCKER_SOCKET || '/var/run/docker.sock';
//
//if (!fs.statSync(socket).isSocket()) {
//  throw new Error("Are you sure the docker is running?");
//}
//
//var docker = new Docker({
//  socketPath: socket
//});

//console.log(config.services);

//docker.version(function(err, data) {
//
//});
//
//docker.listImages(function(err, data) {
//  if (err) {
//    return err;
//  }
//
//  console.log(data);
//});

//pull('simpledrupalcloud/ssh', function() {
//  console.log(1);
//});

//docker.run('simpledrupalcloud/ssh', [''], process.stdout, {
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

//program
//  .command('up')
//    .action(function() {
//    var resolved = dependencies(config.services);
//
//    console.log(resolved);
//
//    for (var i in resolved) {
//      var service = resolved[i];
//
//      var data = config.services[service];
//
//      var image = data.image;
//
//      image_exists(image, function(err) {
//        if (err) {
//
//        }
//      });
//
//      console.log(image);
//
//      for (var j in data.instances) {
//        var instance = data.instances[i];
//
//        console.log(instance);
//
//        docker.pull(image, function(err, stream) {
//          if (err) {
//            return err;
//          }
//
//          stream.pipe(through2(function(chunk, enc, callback) {
//            chunk = JSON.parse(chunk);
//
//            this.push(chunk.status + '\n');
//
//            callback();
//
//          })).pipe(process.stdout);
//        });

//        docker.run(image, [], process.stdout, {
//          Tty: true,
//          name: service + instance
//        }, function(err, data, container) {
//          console.log(1);
//        });
//      }
//    }
//  });

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

program
  .command('config')
  .action(function(action, key, value) {
    var config = new Config();

    switch (action) {
      case 'get':
        config.get(key, function(err, reply) {
          if (err) {
            return console.error(err);
          }
          
          process.stdout.write(reply);
        });

        break;
      case 'set':
        config.set(key, value, function(err, reply) {
          if (err) {
            return console.error(err);
          }

          console.log(reply);
        });

        break;
    }
  });

program.parse(process.argv);
