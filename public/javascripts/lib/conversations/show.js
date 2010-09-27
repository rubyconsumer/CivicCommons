jQuery(function ($) {
  $.fn.extend({
    updateConversationButtonText: function(){
      var el = this;
          parentButton = el.parents('.top-level-contribution').find('.show-conversation-button');
          
      if( /^[^\d]+$/.test(parentButton.data('origText')) ){ // if origText does not contain a number (most likely says something like "Be the first to respond", but we'll be flexible)
        parentButton.data('origText',"0 Response");
      }
      integers = parentButton.data('origText').match(/(\d+)/g);
      $.each(integers, function(){
        incrementedText = parentButton.data('origText').replace(this,parseInt(this)+1).replace(/Response$/, 'Responses');
      });
      parentButton.data('origText', incrementedText);
      
      return el;
    },
    
    scrollTo: function(){
      var top = this.offset().top - 100; // 100px top padding in viewport
      $('html,body').animate({scrollTop: top}, 1000);
      return this;
    }
  });
  
  $(document).ready(function() {
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
  	    $(this).data('cancelText', href.match(/\/conversations\/node_conversation/) ? 'Hide responses' : 'Cancel')
  	    
  	    var label = href.match(/\/conversations\/node_conversation/) ? "Loading responses..." : "Loading...";
  	    $(this).text(label);
  	  })
  	  .live("ajax:complete", function(evt, xhr){
  	    var clicked = this;
  	        target = this.getAttribute("data-target");
  	        tabStrip = target+" .tab-strip";
  	        form = tabStrip+" form";
  	        errorDiv = form+" > .errors";
  	    
  	    // turn button into a toggle to hide/show what gets loaded so that subsequent clicks to redo the ajax call
  	    $(clicked).click(actionToggle(clicked,target,$(clicked).data('cancelText')));
  	    
  	    $(clicked).text($(clicked).data('cancelText'));
        $(target).hide().html(xhr.responseText).slideDown(); // insert content
        $(tabStrip).easyTabs({tabActiveClass: 'tab-active', tabActivePanel: 'panel-active', tabs: '> .tab-area > .tab-strip-options > ul > li'});
        $(form)
          .bind("ajax:loading", function(){
            $(tabStrip).mask("Loading...");
          })
          .bind("ajax:complete", function(){
            $(tabStrip).unmask();
          })
          .bind("ajax:success", function(evt, data, status, xhr){
            $(clicked).updateConversationButtonText().filter(':not(.show-conversation-button)').unbind('click'); // only unbinds the click function that attaches the toggle, since all the other events are indirectly attached through .live()
            var responseNode = $(xhr.responseText);
            $(this).closest('ul.thread-list').append(responseNode);
            $(this).parents('.tab-strip').parent().empty();
            responseNode.scrollTo();
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
});