var fs = require('fs');

var dockerode = require('dockerode');
var through2 = require('through2');

function Image(dockerode) {
  this.dockerode = dockerode;
}

Image.prototype.exists = function(image, callback) {
  var image = this.dockerode.getImage(image);

  image.inspect(function(err) {
    if (err) {
      return callback(false);
    }

    callback(true);
  });
};

function Docker(socket) {
  if (!fs.statSync(socket).isSocket()) {
    throw new Error("Invalid socket provided");
  }

  this.dockerode = new dockerode({
    socketPath: socket
  });

  this.image = new Image(this.dockerode);
}

Docker.prototype.pull = function(image, callback) {
  this.dockerode.pull(image, function(err, stream) {
    if (err) {
      return callback(err);
    }

    stream.pipe(through2(function(chunk, enc, callback) {
      this.push(JSON.parse(chunk).status + '\n');

      callback();
    })).pipe(process.stdout);

    stream.on('end', callback);
  });
};

Docker.prototype.run = function(image, options, callback) {
  var self = this;

  this.image.exists(image, function(exists) {
    if (!exists) {
      return self.pull(image, function(err) {
        callback(err);
      });
    }

    callback(err);
  });
};

module.exports = Docker;
