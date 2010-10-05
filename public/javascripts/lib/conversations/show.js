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
      var top = this.offset().top - 200; // 100px top padding in viewport
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
    $('.rate-form-container').hide();
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
  	        animationSpeed = 250;
  	    
  	    // turn button into a toggle to hide/show what gets loaded so that subsequent clicks to redo the ajax call
  	    $(clicked).click(actionToggle(clicked,target,$(clicked).data('cancelText')));
  	    
  	    $(clicked).text($(clicked).data('cancelText'));
        $(target).hide().html(xhr.responseText).slideDown(); // insert content
        $(tabStrip).easyTabs({
          tabActiveClass: 'tab-active',
          tabActivePanel: 'panel-active',
          tabs: '> .tab-area > .tab-strip-options > ul > li',
          animationSpeed: animationSpeed
        });
        $(form)
          .bind("ajax:loading", function(){
            $(tabStrip).mask("Loading...");
          })
          .bind("ajax:complete", function(){
            $(tabStrip).unmask();
          })
          .bind("ajax:success", function(evt, data, status, xhr){
            // apparently there is no way to inspect the HTTP status returned when submitting via iframe (which happens for AJAX file/image uploads)
            //  so, if file/image uploads via this form will always trigger ajax:success even if action returned error status code.
            //  But for this action, successes always return HTML and failures return JSON of the error messages, so we'll test if response is JSON and trigger failure if so
            try{
              $.parseJSON(data); // throws error if data is not JSON
              return $(this).trigger('ajax:complete').trigger('ajax:failure', xhr, status, data); // only gets to here if JSON parsing was successful, meaning data is error messages
            }catch(err){
              // do nothing
            }
            $(clicked).updateConversationButtonText();
            try{
              var responseNode = $(xhr.responseText);
            }catch(err){
              var responseNode = $($("<div />").html(xhr.responseText).text()); // this is needed to properly unescape the HTML returned from doing the jquery.form plugin's ajaxSubmit for some reason
            }
            $(this).closest('ol.thread-list,ul.thread-list').append(responseNode);
            
            if($(clicked).hasClass('show-conversation-button')){
              $(this).find('textarea,input[type="text"],input[type="file"]').val('');
              $(this).find('.errors').html('');
              window.location.hash = $(this).find('a.cancel').attr('href');
            }else{
              $(clicked).text($(clicked).data('origText')).unbind('click'); // only unbinds the click function that attaches the toggle, since all the other events are indirectly attached through .live()
              $(this).parents('.tab-strip').parent().empty();
            }
            setTimeout(function(){ responseNode.scrollTo(); }, animationSpeed);
          })
          .bind("ajax:failure", function(evt, xhr, status, error){
            var errors = $.parseJSON(xhr.responseText);
            var errorString = "There were errors with the submission:\n";
            for(error in errors){
              errorString += errors[error] + "\n";
            }
            $(this).find(".errors").html(errorString);
          });
      });
      
      $('.rate-form > form')
        .bind("ajax:loading", function(){
          //$(this).closest('.rate-form-container').mask("Loading...");
        })
        .bind("ajax:complete", function(){
          //$(this).closest('.rate-form-container').unmask();
        })
        .bind("ajax:success", function(evt, data, status, xhr){
          $(this).closest('.rate-form-container').siblings('p.rating').text(xhr.responseText);
          $(this).closest('.rate-form-container').remove();
        })
        .bind("ajax:failure", function(evt, xhr, status, error){
          var errors = $.parseJSON(xhr.responseText);
          var errorString = "There were errors with the submission:\n";
          for(error in errors){
            errorString += errors[error] + "\n";
          }
          $(this).find(".errors").html(errorString);
        });
      
      $(document).bind('cbox_closed', function(){
        alert('And this is where we could reload this section of the conversation page!');
      });
  });
});