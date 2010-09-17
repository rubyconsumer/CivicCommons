$(document).ready(function() {
  conversationToggle = function(button,conversation){
    $(button).toggle(
			function(){
				$(this).text("Hide conversation");
				$(conversation).slideDown();
			}, 
			function(){
				$(this).text("Show conversation");
				$(conversation).slideUp();
			}
		);
  }
	$('a.conversation-action')
	  .live("ajax:loading", function(){
	    var href = $(this).attr("href");
	    var label = href.match(/\/conversations\/node_conversation/) ? "Getting conversation..." : "Loading...";
	    $(this).text(label);
	  })
	  .live("ajax:complete", function(evt, xhr){
	    var target = this.getAttribute("data-target");
	    var tabStrip = target+" > .tab-strip";
	    var form = tabStrip+" form";
	    var errorDiv = form+" > .errors";
	    
	    $(this).click(conversationToggle(this,target)); // change this to hide conversation
	    
      $(target).hide().html(xhr.responseText).slideDown(); // insert content
      $(tabStrip).easyTabs({tabActiveClass: 'tab-active', tabActivePanel: 'panel-active'});
      $(form)
        .bind("ajax:loading", function(){
          $(tabStrip).mask("Loading...");
        })
        .bind("ajax:complete", function(){
          $(tabStrip).unmask();
        })
        .bind("ajax:success", function(evt, data, status, xhr){
          $(target).html(xhr.responseText);
        })
        .bind("ajax:failure", function(evt, xhr, status, error){
          var errors = $.parseJSON(xhr.responseText);
          var errorString = "There were errors with the submission:\n";
          for(error in errors){
            errorString += [error] + " " + errors[error] + "\n";
          }
          $(errorDiv).html(errorString);
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