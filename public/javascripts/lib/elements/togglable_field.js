(function() {
  this.TogglableSection = Backbone.View.extend({
    toggleOn: function() {
      $(this.el).parent().find('.section').addClass('hide');
      $(this.el).addClass('active');
      $(this.el).removeClass('hide');
    },
    toggleOff: function() {
      $(this.el).removeClass('active');
    }
  });
}).call(this);
