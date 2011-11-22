context = describe;
beforeEach(function() {

  this.addMatchers({
    toBeTogglable: function() {
      return this.actual.toggle != null
    },
    toHaveSection: function(section) {
      this.message = function() {
        sections = "";
        _.each(this.actual.sections, function(section, key) {
           sections += key+", ";
        });

        return sections + "doesnt have " + section;
      }
      this.actual.sections
      return this.actual.sections[section] != null
    }
  });
});
