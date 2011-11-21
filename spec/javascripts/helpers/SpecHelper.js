context = describe;
beforeEach(function() {

  this.addMatchers({
    toBeTogglable: function() {
      console.log(this.actual.toggle)
      return this.actual.toggle != null
    }
  });
});
