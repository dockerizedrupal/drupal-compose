var redis = require('redis');

function Config() {

}

Config.prototype.get = function(key, callback) {
  var client = redis.createClient();

  client.get(key, function(err, reply) {
    callback(err, reply.toString());

    client.quit();
  });
};

Config.prototype.set = function(key, value, callback) {
  var client = redis.createClient();

  client.set(key, value, function(err, reply) {
    callback(err, reply.toString());

    client.quit();
  });
};

module.exports = Config;
