(function() {

  function authentication_input(name, value) {
    return '<input name="person[authentications_attributes][0]['+name+']" id="person_authentications_attributes_0_'+name+'" value="'+value+'" type="hidden" />';
  }

  var RegistrationPage = {

    submitWithFacebookData: function(data) {
      $('#person_first_name').val(data.user_info.first_name);
      $('#person_last_name').val(data.user_info.last_name);
      $('#person_email').val(data.user_info.email);
      $('form#person_new').append(authentication_input('uid',data.uid));
      $('form#person_new').append(authentication_input('token', data.credentials.token));
      $('form#person_new').append(authentication_input('provider', data.provider));
      $('form#person_new').trigger('submit');
    }
  }
  this.RegistrationPage = RegistrationPage;
}).call(this);
