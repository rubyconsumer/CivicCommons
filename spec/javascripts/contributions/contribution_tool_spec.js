describe("The Conversation Tool", function() {
  var subject;
  var result;
  var $subject; 
  beforeEach(function() {
    $.jasmine.inject('<div class="contribution_tool"><div class="section add_link"><input placeholder="asdf" id="contribution_url"  /><a href="#" id="contribution-add-link" class="contribution-add-link close">Add a link to a related website</a></div><a href="#" id="contribution-add-file" class="close"><p>morkmorkmork</p><form id="contribution_new"><input id="contribution_content" /><input id="contribution_attachment" /></form><ul class="errors"></ul></div>');
    $subject = $('.contribution_tool');
    subject = new ContributionTool({
      el: $subject
    });
  });

  describe('adding a link', function() {
    context('when the link field is hidden', function() {
      beforeEach(function() {
        subject.$linkField.addClass('hide');
        subject.$addLink.click();
      });
      it('unhides the link field', function() {
        expect(subject.$linkField).not.toHaveClass('hide');
      });
      it('activates the add link section', function() {
        expect(subject.$addLinkSection).toHaveClass('active');
      });
    });
    context('cancelling', function() {
      it('removes the value from the textbox', function() {
        subject.$linkField.val('http://www.google.com/');
        subject.$('#contribution-add-link.close').click();
        expect(subject.$linkField.val()).toEqual('');
      });
    });
  });
  describe('adding a file', function() {
    context('cancelling', function() {
      it('removes the file value from input field', function() {
        subject.$fileUploadField.val('/path/to/somewhere');
        subject.$('#contribution-add-file.close').click();
        expect(subject.$fileUploadField.val()).toEqual('');
      });
    });
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
    context('general way',function(){
      beforeEach(function() {
        subject.$linkField.val('http://www.google.com');
        subject.$fileUploadField.val('whatever.js');
        result = subject.submit();
      });
      it('gives error message when link + image are uploaded', function() {
        expect(subject.$('.errors')).toHaveText('Woops! We only let you submit one link or file per contribution');
      });
      it('inserts the error message into the DOM only once', function() {
        subject.submit();
        expect(subject.$('.errors').find(':contains("Woops! We only let you submit one link or file per contribution")').length).toEqual(1);
      });
      it('prevents the event from bubbling any further', function() {
        expect(result).toEqual(false);
      });
    })
    context('when uploading a file only',function(){
      beforeEach(function() {
        subject.$fileUploadField.val('whatever.js');
        result = subject.submit();
      });
      it('should give error message',function(){
        expect(subject.$('.errors')).toHaveText('Sorry! You must also write a comment above when you upload a file.');
      });
      it('inserts the error message into the DOM only once', function() {
        subject.submit();
        expect(subject.$('.errors').find(':contains("Sorry! You must also write a comment above when you upload a file.")').length).toEqual(1);
      });
    });
  });
});

