jQuery(function ($) {
  $(document).ready(function() {
    $('#follow')
  	  .bind("ajax:failure", function(evt, xhr, status, error){
        var errors = $.parseJSON(xhr.responseText);
        var errorString = "There were errors with the submission:\n";
        for(error in errors){
          errorString += errors[error] + "\n";
        }
        $(this).find(".errors").html(errorString);
      });
  });
});
