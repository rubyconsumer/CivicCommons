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
        incrementedText = parentButton.data('origText').replace(this,parseInt(this)+1)
        // if this == 0, then incremented == 1, so no pluralization
        if(this != 0){ incrementedText = incrementedText.replace(/Response$/, 'Responses'); }
      });
      parentButton.data('origText', incrementedText);
      
      return el;
    },
    
    scrollTo: function(){
      var top = this.offset().top - 200; // 100px top padding in viewport
      $('html,body').animate({scrollTop: top}, 1000);
      return this;
    },
    
    bindContributionFormEvents: function(clicked,tabStrip){
      var form = this;
      form
        .maskOnSubmit(tabStrip)
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
          var preview = this.getAttribute('data-preview');
              divId = $(tabStrip).attr('id');
              
          if( $(this).data('jquery-form-submitted') == true ) {
            var responseNode = $($("<div />").html(xhr.responseText).text()); // this is needed to properly unescape the HTML returned from doing the jquery.form plugin's ajaxSubmit for some reason
          } else {
            var responseNode = $(xhr.responseText);            
          }
          
          if(preview == "true") {
            var previewTab = '#' + divId + '-preview'
            // populate the preview div with a preview and a filled-in form with data-preview = false so it can be submitted again
            previewPane = $(this).closest('div').siblings('.contribution-preview');
            
            // bind these ajax handlers to preview form, also add reference to this form on the new preview form
            previewPane.html(responseNode).children('form').bindContributionFormEvents(clicked,tabStrip).data('origForm',$(this));
            
            $(this).find('.validation-error').html(''); // clear any previous errors from form
            window.location.hash = previewTab;
          } else {
            var optionsTab = '#' + divId + '-options';
                origForm = $(this).data('origForm');
            
            if ( $(clicked).hasClass('top-node-conversation-action') ) {
              $.fn.colorbox.close();
              $('ol#conversation-thread-list').append(responseNode).find('.rate-form-container').hide();
            } else {
              $(clicked).updateConversationButtonText();
              $(this).closest('ol.thread-list,ul.thread-list').append(responseNode).find('.rate-form-container').hide();            
              
              if ( $(clicked).hasClass('show-conversation-button') ) {
                origForm.find('textarea,input[type="text"],input[type="file"]').val('');
                origForm.find('[placeholder]').placeholder({className: 'placeholder'});
                $(tabStrip).find('.contribution-preview').html('<a href="#' + divId + '-options" class="button">Respond</a>');
                $(this).find('.validation-error').html('');
              } else {
                $(clicked).text($(clicked).data('origText')).unbind('click'); // only unbinds the click function that attaches the toggle, since all the other events are indirectly attached through .live()
                $(tabStrip).parent().empty();
              }
            }
            window.location.hash = optionsTab;
            setTimeout(function(){ responseNode.scrollTo(); }, 250);
            $(tabStrip).unmask(); // doesn't always unmask on ajax:complete for some reason
          }
        })
        .bindValidationErrorOnAjaxFailure()
        .find('[placeholder]').placeholder({className: 'placeholder'});
        return this
      },
      
      applyEasyTabsToTabStrip: function() {
        this.easyTabs({
          tabActiveClass: 'tab-active',
          tabActivePanel: 'panel-active',
          tabs: '> .tab-area > .tab-strip-options > ul > li',
          defaultTab: '.default-tab',
          animationSpeed: 250
        });
      },
      
      bindValidationErrorOnAjaxFailure: function() {
        this.bind("ajax:failure", function(evt, xhr, status, error){
          try{
            var errors = $.parseJSON(xhr.responseText);
          }catch(err){
            var errors = {msg: "Please reload the page and try again"};
          }
          var errorString = "There were errors with the submission:\n<ul>";
          for(error in errors){
            errorString += "<li>" + error + ' ' + errors[error] + "</li> ";
          }
          errorString += "</ul>"
          this.find(".validation-error").html(errorString);
        });
        return this;
      },
      
      liveAlertOnAjaxFailure: function() {
        this.live("ajax:failure", function(evt, xhr, status, error){
          try{
            var errors = $.parseJSON(xhr.responseText);
          }catch(err){
            var errors = {msg: "Please reload the page and try again"};
          }
          var errorString = "There were errors loading the edit form:\n\n";
          for(error in errors){
            errorString += errors[error] + "\n";
          }
          alert(errorString);
        });
        return this;
      },
      
      maskOnSubmit: function(container) {
        if(container == undefined) { container = this; }
        this
          .bind("ajax:loading", function(){
            $(container).mask("Loading...");
          })
          .bind("ajax:complete", function(){
            $(container).unmask();
          });
        return this;
      },
      
      changeTextOnLoading: function(loadText) {
        if(loadText == undefined) { loadText = "Loading..."; }
        this
          .live("ajax:loading", function(){
            $(this).data('origText', $(this).text());
            $(this).text(loadText);
          })
          .live("ajax:complete", function(evt, xhr){
            $(this).text($(this).data('origText'));
          });
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
  	    $(this).data('origText', $(this).text());
  	    $(this).data('cancelText', href.match(/\/conversations\/node_conversation/) ? 'Hide responses' : 'Cancel');
  	    
  	    var label = href.match(/\/conversations\/node_conversation/) ? "Loading responses..." : "Loading...";
  	    $(this).text(label);
  	  })
  	  .live("ajax:success", function(evt, xhr){
  	    var clicked = this;
  	        target = this.getAttribute("data-target");
  	        tabStrip = target+" .tab-strip";
  	        form = tabStrip+" form";
  	    
  	    // turn button into a toggle to hide/show what gets loaded so that subsequent clicks to redo the ajax call
  	    $(clicked).click(actionToggle(clicked,target,$(clicked).data('cancelText')));
  	    
  	    $(clicked).text($(clicked).data('cancelText'));
        $(target).hide().html(xhr.responseText).slideDown().find('.rate-form-container').hide(); // insert content
        $(tabStrip).applyEasyTabsToTabStrip();

        $(form).bindContributionFormEvents(clicked,tabStrip);
      })
      .liveAlertOnAjaxFailure();
      
      $('.delete-conversation-action')
        .changeTextOnLoading("Deleting...")
        .live("ajax:success", function(evt, data, status, xhr){
          var clicked = this;
    	        target = this.getAttribute("data-target");
          $(target).hide('puff', 1000);
        })
        .liveAlertOnAjaxFailure();
      
      $('.edit-conversation-action')
        .changeTextOnLoading()
        .live("ajax:success", function(evt, data, status, xhr){
          var clicked = this;
    	        target = this.getAttribute("data-target");
    	        form = target + ' form';
          $(target).html(xhr.responseText);
          $(form)
            .maskOnSubmit()
            .bind("ajax:success", function(evt, data, status, xhr){
              contributionContent = $(xhr.responseText).html();
              $(target).html(contributionContent).find('.rate-form-container').hide();
            })
            .bindValidationErrorOnAjaxFailure();
        })
        .liveAlertOnAjaxFailure();
      
      $('.top-node-conversation-action').colorbox({ 
        href: $(this).attr('href'),
        width: '500px',
        height: '300px',
        onComplete: function(){
          var clicked = '#' + $(this).attr('id');
              convoId = clicked.match(/(\d+)/)[0];
              tabStrip = '.tab-strip#conversation-' + convoId;
              form = tabStrip + ' form';
          $(tabStrip).applyEasyTabsToTabStrip();
          $(form).bindContributionFormEvents(clicked,tabStrip);
        }
      });
      
      $('.rate-form-container').hide();
      $('.rate-comment')
        .live("click", function(e){
          $(this.getAttribute("data-target")).toggle();
          e.preventDefault();
        });
      
      $('.rate-form > form')
        .live("ajax:loading", function(){
          $(this).closest('.convo-utility').mask("Loading...");
        })
        .live("ajax:complete", function(){
          $(this).closest('.convo-utility').unmask();
        })
        .live("ajax:success", function(evt, data, status, xhr){
          $(this).closest('.convo-utility').unmask();
          $(this).closest('.rating-container').html(xhr.responseText);
        })
        .live("ajax:failure", function(evt, xhr, status, error){
          try{
            var errors = $.parseJSON(xhr.responseText);
          }catch(err){
            var errors = {msg: "Please reload the page and try again"};
          }
          var errorString = "There were errors with the rating:\n<ul>";
          for(error in errors){
            errorString += "<li>" + error + ' ' + errors[error] + "</li> ";
          }
          errorString += "</ul>"
          $(this).closest(".rate-form").siblings(".validation-error").html(errorString);
        });
        
        $('a[data-colorbox-iframe]').live('click', function(e){
          $.colorbox({ 
            href: $(this).attr('href'), 
            iframe: true, 
            width: '75%', 
            height: '75%',
            onClosed: function(){
              alert('And this is where we could reload this section of the conversation page!');
            }
           });
          e.preventDefault();
        });
  });
});