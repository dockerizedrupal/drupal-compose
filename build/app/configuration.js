var YAML = require('yamljs');

function Dependencies(service) {
  this.service = service;
}

Dependencies.prototype.resolve = function(service) {
  var self = this;

  var resolved = [];

  (function resolve(service, resolved, seen) {
    seen.push(service);

    if (typeof self.configuration.service(service) !== 'undefined' && typeof self.configuration.service(service).dependencies !== 'undefined') {
      for (var dependency in self.configuration.service(service).dependencies) {
        dependency = self.configuration.service(service).dependencies[dependency];

        if (!in_array(dependency, resolved)) {
          if (in_array(dependency, seen)) {
            throw new Error('Circular reference detected: ' + service + ' -> ' + dependency);
          }

          resolve(dependency, resolved, seen);
        }
      }
    }

    resolved.push(service);
  })(service, resolved, []);

  console.log(resolved);

  return resolved;
};

function Service(configuration, serviceName) {
  this.configuration = configuration;
  this.serviceName = serviceName;
}

Service.prototype.name = function() {
  return this.serviceName;
}

Service.prototype.dependencies = function() {
  //new Dependencies(this);

  //return this.configuration.services()
};

function Configuration(filepath) {
  this.configuration = YAML.load(filepath);
}

Configuration.prototype.services = function() {
  var self = this;
  var services = [];

  Object.keys(self.configuration.services).forEach(function(serviceName) {
    services.push(new Service(self, serviceName));
  });

  return services;
};

Configuration.prototype.service = function(serviceName) {
  return new Service(this, serviceName);
};

module.exports = Configuration;

function in_array(value, array) {
  return array.indexOf(value) > -1;
}
