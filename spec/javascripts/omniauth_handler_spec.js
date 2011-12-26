describe('OmniAuth Handler', function () {
  context('When on the registration page', function() {
    it('submit the facebooks', function () {
      spyOn(RegistrationPage,'submitWithFacebookData')
      OmniAuthHandler.handleAccountCreation('word', '/whatever')
      expect(RegistrationPage.submitWithFacebookData).toHaveBeenCalledWith('word')
    });
  })
  context('when not on the registration page', function() {
    it('redirects to whatever its passed in', function() {
      var OldRegPage = _.clone(RegistrationPage);
      RegistrationPage = undefined;
      spyOn(OmniAuthHandler,'redirect')
      OmniAuthHandler.handleAccountCreation('word', '/whatever')
      expect(OmniAuthHandler.redirect).toHaveBeenCalledWith('/whatever')
      RegistrationPage = OldRegPage;
    });
  })
});

