describe('RegistrationPage', function () {
  beforeEach(function() {
    var fields = ['first_name', 'last_name', 'email'];
    $.jasmine.inject('<form id="person_new">');
    _.each(fields, function(field) {
      $.jasmine.inject('<input id="person_'+field+'" />')
    });
  });
  describe('submitting the form with facebook data', function() {
    beforeEach(function() {
      $('form').bind('submit', function() {return false; })
      spyOnEvent($('form'), 'submit');
      RegistrationPage.submitWithFacebookData({ 
        user_info: {
          email: 'zee@zach',
          first_name: "blarp",
          last_name: "narp"
        },
        credentials: {
            token: 'ABC123'
        },
        provider: 'facebook',
        uid: 1234
      });
    });
    it('populates the form with the persons first name', function() {
      expect($('#person_first_name').val()).toEqual('blarp');
    });
    it('populates the form with the persons last name', function() {
      expect($('#person_last_name').val()).toEqual('narp');
    });
    it('populates the form with the email', function() {
      expect($('#person_email').val()).toEqual('zee@zach');
    });
    it('adds in the facebook uid', function() {
      expect($('#person_authentications_attributes_0_uid').val()).toEqual('1234');
    });
    it('adds the facebook token', function() {
      expect($('#person_authentications_attributes_0_token').val()).toEqual('ABC123');
    });
    it('adds the provider', function() {
      expect($('#person_authentications_attributes_0_provider').val()).toEqual('facebook');
    });
    it('submits the form', function() {
      expect('submit').toHaveBeenTriggeredOn($('form#person_new'));
    });
  });
});

