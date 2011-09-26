(function() {
  var $ = jQuery || Zepto

  $.fn.extend({
    maskMe: function(options) {
      preventInvalidOptions(options);
      element = this;
      handler = options.containerToBindEventsTo || element;
      handler.bind(options.startOn, function(e) {
        element.mask(options.message);
      });
      handler.bind(options.endOn, function(e) {
        element.unmask();
      });
    }
  });

  function preventInvalidOptions(options) {
      preventInvalidOption(options, 'startOn', 'You must provide the event to start on');  
      preventInvalidOption(options, 'endOn', 'You must provide the event that stops masking');
  }

  function preventInvalidOption(options, option, message) {
    if(!options[option]) { throw message; }
  }
}).call(this)
