var redis = require('redis');

function Redis() {

}

Redis.prototype.get = function(key, callback) {
  var client = redis.createClient();

  client.get(key, function(err, reply) {
    if (err) {
      return callback(err);
    }

    callback(null, reply.toString());

    client.quit();
  });
};

Redis.prototype.set = function(key, value, callback) {
  var client = redis.createClient();

  client.set(key, value, function(err, reply) {
    if (err) {
      return callback(err);
    }

    callback(null, reply.toString());

    client.quit();
  });
};

module.exports = Redis;
