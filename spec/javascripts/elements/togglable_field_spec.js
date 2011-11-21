describe('a togglable section', function() {
  describe('toggling on a section', function() {
    beforeEach(function() {
      $.jasmine.inject('<div><div class="section section-1">bla</div><div class="section section-2">bla</div></div>');
      section1 = new TogglableSection({ el: '.section-1'});
      section2 = new TogglableSection({ el: '.section-2'});
      section1.toggle();
    });
    it('hides the other sections', function() {
      expect($(section2.el)).toHaveClass('hide');
    });
    it('doesnt hide itself', function() {
      expect($(section1.el)).not.toHaveClass('hide');
    });
    it('activates itself', function() {
      expect($(section1.el)).toHaveClass('active');
    });
  });
});
