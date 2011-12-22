(function() {
  this.OmniAuthHandler = {
    redirect: function(path) {
      window.location = path
    },
    handleAccountCreation: function(person, redirect_location) {
      if(_.isUndefined(window.RegistrationPage)) {
        this.redirect(redirect_location)
      } else {
        RegistrationPage.submitWithFacebookData(person)
      }
    }
  }
}).call(this)
