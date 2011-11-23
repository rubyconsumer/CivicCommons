describe('a togglable section', function() {
  var sections, section1, section2
  beforeEach(function() {
    $.jasmine.inject('<div class="sections"><div class="section-1"><a href="#">bla</a><input value="asdf"/></div><div class="section-2"><a href="#">bla</a></div></div>');
    section = new TogglableSection({ el: 'sections', sections: ['.section-1', '.section-2'] });
    section1 = section.sections['.section-1'];
    section2 = section.sections['.section-2'];
  });
  describe('toggling a section', function() {
    context('when it is active already', function() {
      beforeEach(function() {
        section1.toggle();
        section1.toggle();
      });
      it('deactivates itself', function() {
        expect($(section1.el)).not.toHaveClass('active');
      });
      it('unhides all sections', function() {
        expect($(section.el).find('.hide').length).toEqual(0);
      });
    });
    context('when it is not yet active', function() {
      beforeEach(function() {
        section1.toggle();
      });
      it('hides the other sections', function() {
        expect($(section2.el)).toHaveClass('hide');
      });
      it('activates itself', function() {
        expect($(section1.el)).toHaveClass('active');
      });
    });
  });
});
describe('a togglable field', function() {
  var field;
  beforeEach(function() {
    field = new TogglableField({ el: $('<div class="somefield"><input value="word" class="hide"><a href="#">word</a></div>') });
  });
  describe('toggling the field', function() {
    it('triggers a toggle event', function() {
      spyOn(field,'trigger');
      field.toggle();
      expect(field.trigger).toHaveBeenCalledWith('toggle', field);
    });
    describe('when it is already active', function() {
      beforeEach(function() {
        field.toggle();
        field.toggle();
      });
      it('removes the close class from its link', function() {
        expect(field.$('a')).not.toHaveClass('close');
      });
      it('clears its input field', function() {
        expect(field.$('input')).toHaveValue('');
      });
      it('hides its input field', function() {
        expect(field.$('input')).toHaveClass('hide');
      });
    });
    describe("when it is not yet active", function() {
      var inputFocus;
      var field$;
      beforeEach(function() {
        field.toggle();
      });
      it('adds the close class for its link', function() {
        expect(field.$('a')).toHaveClass('close');
      });
      it('doesnt clear its input', function() {
        expect(field.$('input')).not.toHaveValue('');
      });
      it('unhides its input', function() {
        expect(field.$('input')).not.toHaveClass('hide');
      });
    });
  });
  describe('clicking the fields link', function() {
    it('toggles the field', function() {
      spyOn(field,'toggle');
      field.$('a').click();
      expect(field.toggle).toHaveBeenCalled();
    });
    it('prevents default', function() {
      e = { preventDefault: jasmine.createSpy() };
      field.handleClick(e);
      expect(e.preventDefault).toHaveBeenCalled();
    });
  });
});
