var redis = require('redis');
var synchronize = require('synchronize');

function Config() {

}

Config.prototype.get = function(key) {
  var client = redis.createClient();

  var value = synchronize.await(client.get(key, synchronize.defer()));

  client.quit();

  return value;
};

Config.prototype.set = function(key, value) {
  var client = redis.createClient();

  client.set(key, value);

  client.quit();
};

module.exports = Config;