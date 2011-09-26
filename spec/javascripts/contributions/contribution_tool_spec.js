describe("The Conversation Tool", function() {
  var subject;
  var result;
  var $subject; 
  beforeEach(function() {
    $subject = $('<p>morkmorkmork<form id="contribution_new"><input id="contribution_url" /><input id="contribution_attachment" /></form></p>');
    spyOn($subject, 'maskMe');
    var tabstrip = $('<p>borkborkbork</p>');
    spyOn(tabstrip,'maskMe');  
    subject = new ContributionTool({
      tabstrip: tabstrip,
      el: $subject
    });
    subject.render();
  });

  describe('initialization', function() {

    it('sets up the masking for the tabstrip ', function() {
      expect(subject.tabstrip.maskMe).toHaveBeenCalledWith({
        startOn: 'ajax:loading',
        endOn: 'ajax:complete',
        message: 'Loading...',
        eventHandler: $(subject.el)
      });
    });
    it('sets up masking for itself', function() {
      expect($subject.maskMe).toHaveBeenCalledWith({
        startOn: 'ajax:loading',
        endOn: 'ajax:complete',
        message: 'Loading...',
      });
    });

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

  describe('submitting the form with valid information', function() {
    beforeEach(function() {
        subject.submit();
    });
    it('doesnt give an error message', function() {
      expect(subject.$errorMessage).not.toExist();

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
  });
  describe('submitting a form with invalid inputs', function() {
    it('gives error message when link + image are uploaded', function() {
      subject.$linkField.val('http://www.google.com');
      subject.$fileUploadField.val('whatever.js');
      subject.submit();
      expect(subject.$errorMessage).toHaveText('Woops! We only let you submit one link or file per contribution');   
    });
  });
});

