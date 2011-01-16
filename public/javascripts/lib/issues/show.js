jQuery(function ($){

  $('a.delete')
    .live('ajax:success', function(evt, data, status, xhr){
      $(this).closest('li,div.dnld').remove();
    })
    .live('ajax:failure', function(evt, xhr, status, error){
      try {
        alert( $.parseJSON(xhr.responseText)['base'] );
      } catch(err) {
        alert( 'Something went wrong. Please refresh the page and try again.');
      }
    });

  $('form.contribution-form')
    .live('submit', function(){
      $(this).find('input[placeholder], textarea[placeholder]').each( function() {
        $this = $(this);
        if( $this.val() == $this.attr('placeholder') ){
          $this.val('');
        }
      });
    })
    .live("ajax:success", function(evt, data, status, xhr) {
      try {
        var json = $.parseJSON(data); // throws error if data is not JSON
        if("errors" in json) {return $(this).trigger('ajax:failure', xhr, status, data);} // only gets to here if JSON parsing was successful and has error key
      } catch(err) {  }
      //location.reload();
      
    })
    .live("ajax:failure", function(evt, xhr, status, error) {
      var errors = $.parseJSON(xhr.responseText)['errors'].join("<br/>");
      $(this).find(".errors").html(errors);
    });

	$(document).ready(function(){

      var toggleForm = function(type) {
        $('p#resource-contributions > a.' + type + '-link').click(function() {
          $('p#resource-contributions').hide();
          var formSelector = 'form#new-' + type + '-contribution';
          $(formSelector).show('slow');
          $(formSelector + ' button.cancel').live('click', function() {
            $(formSelector).hide();
            $('p#resource-contributions').show();
            return false;
          });
          return false;
        });
      };
      toggleForm("url");
      toggleForm("file");
      toggleForm("video");
	});
});
