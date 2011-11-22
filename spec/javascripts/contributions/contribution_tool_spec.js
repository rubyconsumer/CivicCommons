describe("The Conversation Tool", function() {
  var subject;
  var result;
  var $subject; 
  beforeEach(function() {
     $subject = $('<div class="contribution_tool"><div class="section add_link"><input placeholder="asdf" id="contribution_url"  /><a href="#" id="contribution-add-link" class="contribution-add-link close">Add a link to a related website</a></div><a href="#" id="contribution-add-file" class="close"><p>morkmorkmork</p><form id="contribution_new"><input id="contribution_content" /><input id="contribution_attachment" /></form><ul class="errors"></ul></div>');
    subject = new ContributionTool({
      el: $subject
    });
  });
  it('has a togglable sections for add-link and add-file', function() {
    expect(subject.attachmentSection).toHaveSection('.add-file');
    expect(subject.attachmentSection).toHaveSection('.add-link');
  });
  describe('submitting the form with valid information', function() {
    beforeEach(function() {
       result = subject.submit();
    });
    it('allows the event to bubble up further', function() {
      expect(result).toEqual(true);
    });
    it('doesnt give an error message', function() {
      expect(subject.$('.errors')).toHaveText('');

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
    context('when uploading a without content',function(){
      beforeEach(function() {
        subject.$fileUploadField.val('whatever.js');
        result = subject.submit();
      });
      it('should give error message',function(){
        expect(subject.$('.errors')).toHaveText('Sorry! You must also write a comment above when you upload a file.');
      });
      it('inserts the error message into the DOM only once', function() {
        expect(subject.$('.errors').find(':contains("Sorry! You must also write a comment above when you upload a file.")').length).toEqual(1);
      });
      it('prevents the submit event from bubbling', function() {
        expect(result).toBeFalsy();
      });
    });
  });
});

