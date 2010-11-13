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
	});
});