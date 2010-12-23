jQuery(function ($){
	$(document).ready(function(){
		$('a.delete').live('click',function(){
			if ( confirm('Are you sure you want to delete this?' ) ){
				var anchor = $(this);
				$.ajax({
					type: 'delete',
					url: anchor.attr('href'),
					complete: function(XMLHttpRequest, textStatus){
						if(textStatus == 'success'){
							//console.log(anchor);
							to_remove = anchor.closest('li, div.dnld');
							to_remove.remove();
						}else{
							alert( "something failed" );
						}
					},
	        error: function (XMLHttpRequest, textStatus, errorThrown) {
						var error = $.parseJSON(XMLHttpRequest.responseText)['base'];
	          alert(error);
	        }
				});
			}
			return false;
		});

    $('form.contribution-form')
      .bind('submit', function(){
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
        location.reload();
      })
      .live("ajax:failure", function(evt, xhr, status, error) {
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
