jQuery(function ($) {

  // Log all jQuery AJAX requests to Google Analytics
  $(document).ajaxSend(function(event, xhr, settings){ 
    _gaq.push(['_trackPageview', settings.url]);
    if ( settings.url != "/people/ajax_login" ) {
      lastAjaxSettings = settings;
    }
  });

  $('#ajax-login-form')
  .live('ajax:success', function(evt, data, status, xhr){
   // console.log(lastAjaxSettings);
   // $.ajax({
   //   url: lastAjaxSettings.url,
   //   data: lastAjaxSettings.data,
   //   dataType: lastAjaxSettings.dataType,
   //   type: lastAjaxSettings.type,
   //   beforeSend: lastAjaxSettings.beforeSend,
   //   success: lastAjaxSettings.success,
   //   complete: lastAjaxSettings.complete,
   //   error: lastAjaxSettings.error
   // });
  })
  .live('ajax:failure', function(evt, xhr, status, error){
    alert('Login failed!');
  })

});

$(document).ready(function(){
  if(typeof(Modernizr) != "undefined" && !Modernizr.input.placeholder) {
    $('[placeholder]').placeholder({className: 'placeholder'});
  }
  $('a[data-colorbox]').live('click', function(e){
    $.colorbox({ 
      transition: 'fade', // needed to fix colorbox bug with jquery 1.4.4
      href: $(this).attr('href') 
    });
    e.preventDefault();
  });
});

var civic = function() {
  var displayMessage = function(message, cssClass) {
    var messageDiv = $("<div>")
      .addClass(cssClass)
      .addClass("message")
      .text(message)
      .appendTo($("body")); 

    setTimeout(function() { messageDiv.fadeOut();}, 4000);
  };
  var self = {};
  self.error = function(message) { displayMessage(message, "error"); };
  self.alert = function(message) { displayMessage(message, "alert"); };
  return self;
}();

