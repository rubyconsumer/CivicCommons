(function() {
  this.TogglableSection = Backbone.View.extend({
    toggle:function() {
      $(this.el).parent().find('.section').addClass('hide');
      $(this.el).addClass('active');
      $(this.el).removeClass('hide');
    }
  });
}).call(this);
