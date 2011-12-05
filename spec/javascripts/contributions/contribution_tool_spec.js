describe("The Conversation Tool", function() {
  var subject;
  var result;
  var $subject;
  beforeEach(function() {
     $.jasmine.inject('<script id="attachment-fields-template" type="text/tmpl"><div class="attachments"><div class="add-link"><input placeholder="asdf" /><a href="#">Add link</a></div><div class="add-file"><a href="#">add file</a><input></div></div></script><form><input class="content" /><fieldset class="errors"><ul class="errors"></ul></fieldset></form>');

    subject = new ContributionTool({
      el: 'form'
    });
  });
  it('has a togglable sections for add-link and add-file', function() {
    expect(subject.attachmentSection).toHaveSection('.add-file');
    expect(subject.attachmentSection).toHaveSection('.add-link');
  });
  it('clears out the link field', function() {
    subject.$linkField.val('asdf');
    subject.initialize();
    expect(subject.$linkField).toHaveValue('');
  });
  it('clears out the link field', function() {
    subject.$fileUploadField.val('asdf');
    subject.initialize();
    expect(subject.$fileUploadField).toHaveValue('');
  });
  describe('submitting the form with valid information', function() {
    context('with only content', function() {
      beforeEach(function() {
         subject.$contentField.val('asdf');
         result = subject.submit();
      });
      it('allows the event to bubble up further', function() {
        expect(result).toEqual(true);
      });
      it('doesnt give an error message', function() {
        expect(subject.$('.errors')).toHaveText('');
      });
    });
    context('with just a url', function() {
      it('succeeds', function() {
        subject.$linkField.val('facebook.com');
        expect(subject.$('.errors')).toHaveText('');
        expect(subject.submit()).toBeTruthy();
      });
    });
    context("when there is placeholder information", function() {
      it("clears the value", function() {
        expect(subject.$('*[placeholder]')).toHaveValue('');
      });
    });
    context("when the placeholder value has been replaced", function() {
      it('leaves the values as is', function() {
        subject.$('*[placeholder]').val('cool');
        subject.submit();
        expect(subject.$('*[placeholder]')).toHaveValue('cool');
      });
    });
  });
  describe('submitting a form with invalid inputs', function() {
    context('when uploading a file without content',function(){
      beforeEach(function() {
        subject.$('.add-file input').val('whatever.js');
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

