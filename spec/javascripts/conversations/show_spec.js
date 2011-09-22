describe('showing conversations', function () {
  subject = new ShowsConversations();
  describe('the document ready function', function() {
    beforeEach(function() {
      spyOn(subject, 'scrollToContributionDenotedByWindowsLocationHash');
      setFixtures('<a class="rating-button">Yarp</a>'); 
      spyOn($.fn,'ratingButton').andCallFake(function() {
        expect($(this)).toBe('.rating-button');
      });
      subject.domReadyHandler();
    });
    it('initializes rating-buttons on elements with class rating-button', function() {
      expect($.fn.ratingButton).toHaveBeenCalled();
    });
    it('scrolls to the contribution denoted by the windows hash', function() {
      expect(subject.scrollToContributionDenotedByWindowsLocationHash).toHaveBeenCalled();
    });
  });
  describe('scrolling to a contribution', function() {
    context('when the contribution is 1234', function() {
      it('scrolls to 1234', function() {
        setFixtures('<div id="show-contribution-1234">Yarp</div>');
        spyOn($.fn,'scrollTo').andCallFake(function() {
            expect($(this)).toBe('#show-contribution-1234')
        });
        subject.scrollToContribution(1234);
        expect($.fn.scrollTo).toHaveBeenCalled();
      });
    });
  });
  describe('scrolling to a contribution denoted by the windows hash', function() {
    context('the window hash is node-1234', function() {
      it('scrolls to contribution 1234', function() {
        setFixtures('<div id="show-contribution-1234">Yarp</div>');
        spyOn($,'getHash').andReturn('node-1234')
        spyOn(subject, 'scrollToContribution');
        subject.scrollToContributionDenotedByWindowsLocationHash();
        
        expect(subject.scrollToContribution).toHaveBeenCalledWith(1234);
      });
    });
  });
});

