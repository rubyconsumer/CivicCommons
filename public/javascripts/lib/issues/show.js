jQuery(function ($){

  $('a.delete')
    .live('ajax:success', function(evt, data, status, xhr){
      $(this).closest('li,div.dnld').remove();
    })
    .live('ajax:error', function(evt, xhr, status, error){
      try {
        alert( $.parseJSON(xhr.responseText)['base'] );
      } catch(err) {
        alert( 'Something went wrong. Please refresh the page and try again.');
      }
    });

  

	$(document).ready(function(){

    selectResponseFromHash = function(){
      var hash = window.location.hash.match(/^#node-([\d]+)/);

      if ( hash && hash[1] ){
        var responseId = hash[1],
            $onPage = $('#contribution-' + responseId);

        // Permalink to contribution already on page (e.g. TopLevelContribution)
        if ( $onPage.size() > 0 ) {
          return $onPage.scrollTo();
        }
      }
    }
    selectResponseFromHash();

    $('form.contribution-form')
      .bind('submit', function(e){
        $(this).find('input[placeholder], textarea[placeholder]').each( function() {
          $this = $(this);
          if( $this.val() == $this.attr('placeholder') ){
            $this.val('');
          }
        });
        if($(this).hasClass('file-form')) {
          e.preventDefault();
          $(this).ajaxSubmit({
            url: $(this).attr('action'),
            dataType: 'script',
            beforeSend: function (xhr) {
              $this.trigger('ajax:loading', xhr);
            },
            success: function (data, status, xhr) {
              $this.trigger('ajax:success', [data, status, xhr]);
            },
            complete: function (xhr) {
              $this.trigger('ajax:complete', xhr);
            },
            error: function (xhr, status, error) {
              $this.trigger('ajax:error', [xhr, status, error]);
            }
          });
        }
      })
      .bind('ajax:loading', function(){
        $(this).mask('Loading...');
      })
      .bind('ajax:complete', function(){
        $(this).unmask();
      })
      .bind("ajax:success", function(evt, data, status, xhr) {
        try {
          var json = $.parseJSON(data); // throws error if data is not JSON
          if("errors" in json) {return $(this).trigger('ajax:error', xhr, status, data);} // only gets to here if JSON parsing was successful and has error key
        } catch(err) {  }
        // Don't do anything (will be handled by create_contribution.js.erb)
      })
      .bind("ajax:error", function(evt, xhr, status, error) {
        var errors = $.parseJSON(xhr.responseText)['errors'].join("<br/>");
        $(this).find(".errors").html(errors);
      });

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
