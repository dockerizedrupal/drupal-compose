var YAML = require('yamljs');

function DependencyResolver(configuration) {
  this.configuration = configuration;
}

DependencyResolver.prototype.resolve = function() {
  var resolved = [];

//  (function resolve(service, resolved, seen) {
//    seen.push(service);
//
//    if (typeof services[service] !== 'undefined' && typeof services[service].requires !== 'undefined') {
//      for (var dependency in services[service].requires) {
//        dependency = services[service].requires[dependency];
//
//        if (!in_array(dependency, resolved)) {
//          if (in_array(dependency, seen)) {
//            throw new Error('Circular reference detected: ' + service + ' -> ' + dependency);
//          }
//
//          resolve(dependency, resolved, seen);
//        }
//      }
//    }
//
//    resolved.push(service);
//  })(Object.keys(services)[0], resolved, []);

  return resolved;
};

function Configuration(filepath) {
  this.configuration = YAML.load(filepath);

  this.dependencies = new DependencyResolver(this.configuration);
}

Configuration.prototype.services = function() {
  var services = [];

  this.configuration.services.forEach(function(service) {
    console.log(service);
  });

  return services;
}

module.exports = Configuration;


function in_array(value, array) {
  return array.indexOf(value) > -1;
}
