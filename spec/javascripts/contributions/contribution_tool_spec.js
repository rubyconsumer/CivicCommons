describe("The Conversation Tool", function() {
  var subject;
  var result;
  beforeEach(function() {

    subject = new ContributionTool({
      tabstrip: $('<p>borkborkbork</p>')
    });
    subject.render();
    spyOn(subject.tabstrip,'maskChild');  
  });

  describe('rendering', function() {
    beforeEach(function() {
      result = subject.render();
    })

    it('is chainable', function() {
      expect(result).toEqual(subject);
    });

    it('makes the element look like the contribution tool', function() {
      expect($(subject.el)).toHaveHtml(subject.template());
    });
  });

  describe('submitting the form', function() {
    beforeEach(function() {
        subject.submit();
    });
    context("when there is placeholder information", function() {
      it("clears the value", function() {
        expect(subject.$('*[placeholder]')).toHaveValue('');
      });
    });

    context("when the placeholder value has been replaced", function() {
      it('leaves the values as is', function() {
        subject.$('*[placeholder]').val('cool') 
        subject.submit();
        expect(subject.$('*[placeholder]')).toHaveValue('cool');
      });
    });
    it('masks the tabstrip it is created with', function() {
      expect(subject.tabstrip.maskChild).toHaveBeenCalled();
    });
  });

});
$.fn.extend({
  maskChild: function(child) {

  }
});
