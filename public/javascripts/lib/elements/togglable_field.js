(function() {
  this.TogglableSection = Backbone.View.extend({
    templateId: "attachment-fields-template",
    initialize: function(options) {
      this.template = _.template($("#" + this.templateId).html());
      this.sections = {};
    },
    toggle: function(field) {
      $(field.el).toggleClass('active');
      _.each(this.sections, function(section) {
        if(section != field) {
          $(section.el).toggleClass('hide');
        }
      });
    },
    setUp: function() {
      var options = this.options;
      var section;
      _.each(options.sections, function(sectionLocator) {
        section = new TogglableField({ el: this.$(sectionLocator) });
        var self = this;
        section.bind('toggle', function(field) {
          self.toggle(field);
        });
        if($(section.el).hasClass('active')) { section.toggle(); }
        this.sections[sectionLocator] = section;
      }, this);
    },
    render: function() {
      $(this.el).html(this.template());
      this.setUp();
      return this;
    }
  });
  this.TogglableField = Backbone.View.extend({
    events: {
      'click a': 'handleClick'
    },
    initialize: function() {
        $(this.el).addClass('section');
        if($(this.el).hasClass('active')) { this.toggle(); }
    },
    toggle: function() {
      this.active = this.active ? false : true;
      this.$('a').toggleClass('close');
      this.$('input').toggleClass('hide');
      if(!this.active) {
        this.$('input').val('');
      } else {
        this.$('input').focus();
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
