jQuery(function ($) {

  // Log all jQuery AJAX requests to Google Analytics
  $(document).ajaxSend(function(event, xhr, settings){ 
    // console.log(settings.url);
    _gaq.push(['_trackPageview', url]);
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

