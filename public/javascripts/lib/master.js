var lastAjaxSettings;

(function ($) {
  $.fn.extend({
    scrubPlaceholderText: function(){
      $(this).find('input[placeholder], textarea[placeholder]').each( function() {
        $this = $(this);
        if( $this.val() == $this.attr('placeholder') ){
          $this.val('');
        }
      });
    },
    scrollTo: function(){
      var $this = this;
      if(this.offset() == undefined) { return; }
      var top = this.offset().top - 100; // 100px top padding in viewport,
      var origBG = this.css('background') || 'transparent';
      var scrolled = false; // Hack since 'html,body' is the only cross-browser compatible way to scroll window

      $('html,body').animate({scrollTop: top}, 1000, function (){
        if ( ! scrolled ) { $this.effect('highlight', {color: '#c5d36a'}, 3000); }
        scrolled = true;
      });
      return $this;
    }
  });
})(jQuery);

jQuery(function ($) {

  // Log all jQuery AJAX requests to Google Analytics
  $(document).ajaxSend(function(event, xhr, settings){
    if(typeof(_gaq) != 'undefined') {
      _gaq.push(['_trackPageview', settings.url]);
      if ( settings.url != "/people/ajax_login" ) {
        lastAjaxSettings = settings;
        lastAjaxEvent = event;
        lastAjaxIsColorbox = $('#colorbox').is(':visible');
      }
    }
  });

  $('#ajax-login-form')
  .live('ajax:error', function(evt, xhr, status, error){
    alert('Login failed!');
  });


});

$(document).ready(function(){
  if(typeof(Modernizr) != "undefined" && !Modernizr.input.placeholder) {
    $('[placeholder]').addClass('placeholder');
  }
  $('a[data-colorbox]').live('click', function(e){
    $.colorbox({ 
      transition: 'fade', // needed to fix colorbox bug with jquery 1.4.4
      href: $(this).attr('href') 
    });
    e.preventDefault();
  });

  $('.flash-notice').show('blind');
  setTimeout(function(){
    $('.flash-notice').hide('blind');
  },5000);
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

