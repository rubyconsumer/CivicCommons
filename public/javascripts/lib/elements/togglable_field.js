(function() {
  this.TogglableSection = Backbone.View.extend({
    initialize: function(options) {
      this.sections = {};
      var section;
      _.each(options.sections, function(sectionLocator) {
        section = new TogglableField({ el: this.$(sectionLocator) });
        var self = this;
        section.bind('toggle', function(field) {
          self.toggle(field);
        });
        this.sections[sectionLocator] = section
      }, this);
    },
    toggle: function(field) {
      $(field.el).toggleClass('active');
      _.each(this.sections, function(section) {
        if(section != field) {
          $(section.el).toggleClass('hide');
        }
      });
    },
  });
  this.TogglableField = Backbone.View.extend({
    events: {
      'click a': 'handleClick'
    },
    initialize: function() {
        $(this.el).addClass('section');
    },
    toggle: function() {
      this.active = this.active ? false : true
      this.$('a').toggleClass('close');
      if(!this.active) {
        this.$('input').val('');
      }
      this.trigger('toggle', this);
    },
    hide: function() {
      $(this.el).addClass('hide');
    },
    handleClick: function(e) {
      e.preventDefault();
      this.toggle();
    }
  });
}).call(this);
