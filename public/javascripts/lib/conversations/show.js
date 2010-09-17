$(document).ready(function() {
	$('a.conversation-action')
	  //.bind("ajax:loading", toggleLoading)
	  .bind("ajax:complete", function(et, e){
	    var target = this.getAttribute("data-target");
      $(target).html(e.responseText); // insert content
      $(target+" > .tab-strip").easyTabs({tabActiveClass: 'tab-active', tabActivePanel: 'panel-active'});
      $(target+" > .tab-strip form")
        .bind("ajax:success", function(et, e){
          $(target).html(e.responseText);
        })
        .bind("ajax:complete", function(et, e){
          var errors = $.parseJSON(e.responseText);
          var errorString = "There were errors with the submission:\n";
          for(error in errors){
            errorString += [error] + " " + errors[error] + "\n";
          }
          $(target+" > .tab-strip form > .errors").html(errorString);
        });
    });
	
	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
  
});

function ShowError(xhr, status, error, memo) {
var string = "There was a " + status + " in " + memo + ".\n"
	if (error) {
		string += " The error text is " + error.toString() + ".\n"
	}
	if (xhr) {
		string += " Status: " + xhr.status + "\n";
		string += " See server log for details.\n";
	}
	alert(string);
}

//function RateConversation(conversation_id, rating) {
//	var data = "";
//	data = data + "conversation_id=" + $("#conversation_id").val();
//	data = data + "&rating="+rating;
//	
//	$.ajax({
//		url: "/conversations/rate",
//		type: "POST",
//		data: data,
//		success: function(response) {
//			var rating = parseInt(response);
//			if (rating == 0)
//				$("#conversation_rating a.current_rating").html(response)
//			else if (rating > 0)
//				$("#conversation_rating a.current_rating").html("+"+response)
//			else
//				$("#conversation_rating a.current_rating").html("-"+response)			
//			
//		},
//		error: function(xhr, status, error) {
//		}
//	})
//}