var lastAjaxSettings;

jQuery(function ($) {

  // Log all jQuery AJAX requests to Google Analytics
  $(document).ajaxSend(function(event, xhr, settings){ 
    _gaq.push(['_trackPageview', settings.url]);
    if ( settings.url != "/people/ajax_login" ) {
      lastAjaxSettings = settings;
      lastAjaxEvent = event;
      lastAjaxIsColorbox = $('#colorbox').is(':visible');
    }
  });

  $('#ajax-login-form')
  .live('ajax:failure', function(evt, xhr, status, error){
    alert('Login failed!');
  })

  $.fn.extend({
    scrollTo: function(){
      var $this = this,
          top = this.offset().top - 200, // 100px top padding in viewport,
          origBG = this.css('background') || 'transparent',
          scrolled = false; // Hack since 'html,body' is the only cross-browser compatible way to scroll window
                            // which causes callback to run twice.

      $('html,body').animate({scrollTop: top}, 1000, function (){
        if ( ! scrolled ) { $this.effect('highlight', {color: '#c5d36a'}, 3000); }
        scrolled = true;
      });
      return $this;
    }
  });

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

