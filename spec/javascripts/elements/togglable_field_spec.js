describe('a togglable section', function() {
  var section1, section2
  beforeEach(function() {
    $.jasmine.inject('<div><div class="section section-1">bla</div><div class="section section-2">bla</div></div>');
    section1 = new TogglableSection({ el: '.section-1'});
    section2 = new TogglableSection({ el: '.section-2'});
  });
  describe('toggling on a section', function() {
    beforeEach(function() {
      section1.toggleOn();
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
  describe('toggling off a section', function() {
    beforeEach(function() {
      section1.toggleOff();
    });
    it('deactivates itself', function() {
      expect($(section1.el)).not.toHaveClass('active');
    });
    it('unhides the other section', function() {
      expect($(section2.el)).not.toHaveClass('hide')
    });
  });
});
