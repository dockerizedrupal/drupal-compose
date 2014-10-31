var toposort = require('toposort');

module.exports = function(containers) {
  return {
    start_order: function() {
      var edges = [];
      var nodes = Object.keys(containers);

      nodes.forEach(function(name) {
        var container = containers[name];

        if (typeof container.links !== 'undefined') {
          Object.keys(container.links).forEach(function(link) {
            edges.push([name, link]);
          });
        }
      });

      return toposort.array(nodes, edges).reverse();
    }
  }
};
