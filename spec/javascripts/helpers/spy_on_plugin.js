(function() {

  $ = this.jQuery;

  this.spyOnPlugin = function(plugin) {
    createPluginSpyFor(plugin)
  };

  spiedPlugins = {}; 

  var createPluginSpyFor = function(plugin) {
    if(wasSpiedOn(plugin)) { return; }

    spiedPlugins[plugin] = [];
    spyOn($.fn, plugin).andCallFake(function() {
      spiedPlugins[plugin].push(this.selector);
    });
  }

  var cleanUp = function() { spiedPlugins = {}; }

  var wasSpiedOn = function(plugin) {
    return spiedPlugins[plugin] != undefined;
  }

  var wasCalledOn = function(selector, plugin) {
    return _.include(spiedPlugins[plugin], selector);
  } 
  
  var matchers = {

    pluginToHaveBeenCalledOn: function(selector) {
      if (!wasSpiedOn(this.actual)) {
        throw new Error('Expected a plugin spy for $.fn.' + this.actual +'. Make sure you use spyOnPlugin');
      }

      this.message = function() {
        return [
          "Expected plugin " + this.actual + " to have been called on " + selector,
          "Expected plugin " + this.actual + " not to have been called on " + selector
        ];
      }
      return wasCalledOn(selector, this.actual)
    }
  }

  beforeEach(function() {
    this.addMatchers(matchers);
  });

  afterEach(function() {
    cleanUp();
  });

}).call(this)
