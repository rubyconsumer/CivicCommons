//$.fn.extend({
//  updateButtonText: function(){
//    var el = this;
//    if(el.data('origText')!='Respond'){
//      if( /^[^\d]+$/.test(el.data('origText')) ){ // if origText does not contain a number (most likely says something like "Be the first to respond", but we'll be flexible)
//        el.data('origText',"View conversation (0)");
//      }
//      var integers = el.data('origText').match(/(\d+)/g);
//      $.each(integers, function(){
//        incrementedText = el.data('origText').replace(this,parseInt(this)+1);
//      });
//      $(el).data('origText', incrementedText);
//    }
//    if( el.attr("href").match(/\/conversations\/node_conversation/) ){
//      el.text(el.data('cancelText'));
//    }else{
//      el.text(el.data('origText'));
//    }
//  },
//  
//  scrollTo: function(){
//    var top = $(this).offset().top - 100; // 100px top padding in viewport
//    $('html,body').animate({scrollTop: top}, 1000);
//  }
//});

$(document).ready(function() {
  updateButtonText = function(node){
    var el = $(node);
    if(el.data('origText')!='Respond'){
      if( /^[^\d]+$/.test(el.data('origText')) ){ // if origText does not contain a number (most likely says something like "Be the first to respond", but we'll be flexible)
        el.data('origText',"View conversation (0)");
      }
      var integers = el.data('origText').match(/(\d+)/g);
      $.each(integers, function(){
        incrementedText = el.data('origText').replace(this,parseInt(this)+1);
      });
      $(el).data('origText', incrementedText);
    }
    if( /^[^\d]+$/.test(el.data('origText')) ){
      el.text(el.data('origText'));
    }else{
      el.text('Respond');
    }
  }
  
  scrollTo = function(node){
    var top = node.offset().top - 100; // 100px top padding in viewport
    $('html,body').animate({scrollTop: top}, 1000);
  }
  actionToggle = function(clicked,target,clickedCancelText){
    $(clicked).toggle(
  		function(){
  			$(this).text(clickedCancelText);
  			$(target).slideDown();
  		}, 
  		function(){
  			$(this).text($(this).data('origText'));
  			$(target).slideUp();
  		}
  	);
  }
	$('a.conversation-action')
	  .live("ajax:loading", function(){
	    var href = $(this).attr("href");
	    $(this).data('origText', $(this).text())
	    $(this).data('cancelText', href.match(/\/conversations\/node_conversation/) ? 'Hide conversation' : 'Cancel')
	    
	    var label = href.match(/\/conversations\/node_conversation/) ? "Getting conversation..." : "Loading...";
	    $(this).text(label);
	  })
	  .live("ajax:complete", function(evt, xhr){
	    var clicked = this;
	    var target = this.getAttribute("data-target");
	    var tabStrip = target+" > .tab-strip";
	    var form = tabStrip+" form";
	    var errorDiv = form+" > .errors";
	    
	    // turn button into a toggle to hide/show what gets loaded so that subsequent clicks to redo the ajax call
	    $(clicked).click(actionToggle(clicked,target,$(clicked).data('cancelText')));
	    
	    $(clicked).text($(clicked).data('cancelText'));
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
          updateButtonText(clicked);
          //$(clicked).updateButtonText();
          $(clicked).unbind('click'); // only unbinds the click function that attaches the toggle, since all the other events are indirectly attached through .live()
          $(target).empty();
          var responseNode = $(xhr.responseText)
          $(target).parent().append(responseNode);
          scrollTo(responseNode);
          //responseNode.scrollTo();
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
	
//	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
  
});

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