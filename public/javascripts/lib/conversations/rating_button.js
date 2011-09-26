(function() {
  $ = this.jQuery;

  $.fn.extend({
    ratingButton: function() {
      var button = this;
      button.live('ajax:before', function() {
       button.children('.loading').show();
      });
      button.live('ajax:complete', function() {
        button.children('.loading').hide();
      });
      return this;
    }
  });


}).call(this);
