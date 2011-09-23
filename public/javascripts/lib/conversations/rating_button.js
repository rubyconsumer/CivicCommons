(function() {
  $ = this.jQuery;

  $.fn.extend({
    ratingButton: function() {
      this.live('ajax:before', function() {
       $(this).children('.loading').show();
      });
      this.live('ajax:complete', function() {
        $(this).children('.loading').hide();
      });
      return this;
    }
  });


}).call(this);
