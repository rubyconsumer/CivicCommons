describe('showing conversations', function () {
  var subject;
  beforeEach(function() {
    subject = new ShowsConversations();
  });
  describe('instantiation', function() {
  });
  describe('the document ready function', function() {
    beforeEach(function() {
      spyOn(subject, 'scrollToContributionDenotedByWindowsLocationHash');
      spyOnPlugin('ratingButton')
      subject.onReady();
    });
    it('initializes rating-buttons on elements with class rating-button', function() {
      expect('ratingButton').pluginToHaveBeenCalledOn('.rating-button');
    });
    it('scrolls to the contribution denoted by the windows hash', function() {
      expect(subject.scrollToContributionDenotedByWindowsLocationHash).toHaveBeenCalled();
    });
  });
  describe('scrolling to a contribution denoted by the windows hash', function() {
    beforeEach(function() {
      spyOnPlugin('scrollTo');
    });
    context('the window hash is node-1234', function() {
      it('scrolls to contribution 1234', function() {
        spyOn(ParseHashFor,'contributionId').andReturn('1234')
        subject.scrollToContributionDenotedByWindowsLocationHash();
        expect('scrollTo').pluginToHaveBeenCalledOn('#show-contribution-1234');
      });
    });
    context('the window hash is node-45667', function() {
      it('scrolls to contribution 45667', function() {
        spyOn(ParseHashFor,'contributionId').andReturn('45567')
        subject.scrollToContributionDenotedByWindowsLocationHash();
        expect('scrollTo').pluginToHaveBeenCalledOn('#show-contribution-45567');
      });
    });
  });
});
