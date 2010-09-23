$(document).ready(function() {
  scrollTo = function(node) {
     var top = node.offset().top - 100; // 100px top padding in viewport
     $('html,body').animate({scrollTop: top}, 1000);
  }
  actionToggle = function(button,action){
    var href = $(button).attr("href");
    $(button).toggle(
			function(){
				$(this).text(href.match(/\/conversations\/node_conversation/) ? 'Hide conversation' : 'Cancel');
				$(action).slideDown();
			}, 
			function(){
				$(this).text($(this).data('origText'));
				$(action).slideUp();
			}
		);
  }
	$('a.conversation-action')
	  .live("ajax:loading", function(){
	    var href = $(this).attr("href");
	    var label = href.match(/\/conversations\/node_conversation/) ? "Getting conversation..." : "Loading...";
	    
	    $(this).data('origText', $(this).text()).text(label);
	  })
	  .live("ajax:complete", function(evt, xhr){
	    var clicked = this;
	    var target = this.getAttribute("data-target");
	    var tabStrip = target+" > .tab-strip";
	    var form = tabStrip+" form";
	    var errorDiv = form+" > .errors";
	    
	    $(clicked).click(actionToggle(clicked,target)); // turn button into a toggle to hide/show what gets loaded so that subsequent clicks to redo the ajax call
	    
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
          $(clicked).text($(clicked).data('origText'));
          $(target).empty();
          var responseNode = $(xhr.responseText)
          $(target).parent().append(responseNode);
          scrollTo(responseNode);
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