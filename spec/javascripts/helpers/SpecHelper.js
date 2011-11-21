context = describe;
beforeEach(function() {

  this.addMatchers({
    toBeTogglable: function() {
      return this.actual.toggle != null
    }
  });
});
