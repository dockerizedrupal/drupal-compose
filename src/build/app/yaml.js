var fs = require('fs');

var yaml = require('js-yaml');

module.exports = {
  load: function(filename) {
    var doc = '';

    try {
      doc = yaml.safeLoad(fs.readFileSync(filename, 'utf-8'));
    }
    catch (e) {
      console.log(e);
    }

    return doc;
  }
};
