jQuery(function ($) {
  $.fn.extend({
    updateConversationButtonText: function(){
      var el = this;
          parentButton = el.parents('.top-level-contribution').find('.show-conversation-button');
      
      if(parentButton.size() == 0) { return el; } // there is no parent button if responding to convo-level responses at bottom of convo perma page
          
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
          var preview = this.getAttribute('data-preview'),
              divId = $(tabStrip).attr('id'),
              responseNode;
              
          if( $(this).data('jquery-form-submitted') == true ) {
            responseNode = $($("<div />").html(xhr.responseText).text()); // this is needed to properly unescape the HTML returned from doing the jquery.form plugin's ajaxSubmit for some reason
          } else {
            responseNode = $(xhr.responseText);            
          }
          
          if(preview == "true") {
            var previewTab = '#' + divId + '-preview',
                // populate the preview div with a preview and a filled-in form with data-preview = false so it can be submitted again
                previewPane = $(this).closest('div').siblings('.contribution-preview');
            
            // bind these ajax handlers to preview form, also add reference to this form on the new preview form
            previewPane.html(responseNode).children('form').bindContributionFormEvents(clicked,tabStrip).data('origForm',$(this));
            
            $(this).find('.validation-error').html(''); // clear any previous errors from form
            $(tabStrip).easytabs('select','li.preview-tab').find(".contribution-preview").find("a.cancel").click(function(e){
              $(tabStrip).easytabs('select', $(this).attr("href"));
              e.preventDefault();
            });
          } else {
            var optionsTab = '#' + divId + '-options',
                origForm = $(this).data('origForm');
            
            if ( $(clicked).hasClass('top-node-conversation-action') ) {
              $.fn.colorbox.close();
              $('ol#conversation-thread-list').append(responseNode).find('.rate-form-container').hide();
            } else {
              $(clicked).updateConversationButtonText();
              $(clicked)
                .text($(clicked).data('origText'))
                .unbind('click'); // only unbinds the click function that attaches the toggle, since all the other events are indirectly attached through .live()
              
              if ( $(clicked).hasClass('top-level-contribution-action-button') ) {
                var $showResponsesButton = $(clicked).closest('.response').find('.show-conversation-button');
                if ( ! $showResponsesButton.data('expanded') ) {
                  $showResponsesButton.click(); // expands
                }
              }
              
              $(this).appendContributionToThread(responseNode);
              $(tabStrip).parent().empty();
            }
            setTimeout(function(){ responseNode.scrollTo(); }, 250);
            $(tabStrip).easytabs('select', optionsTab);
            $(tabStrip).unmask(); // doesn't always unmask on ajax:complete for some reason
          }
        })
        .bindValidationErrorOnAjaxFailure()
        .find('[placeholder]').placeholder({className: 'placeholder'});
        return this
      },
      
      appendContributionToThread: function(responseNode) {
        var $target = this.closest('ol.thread-list,ul.thread-list').find('.contribution-thread-div').first(),
            contribution = responseNode.children('li').attr('id'),
            $contributionOnPage = $target.find('li#' + contribution);
            
        if ( $contributionOnPage.size > 0 ){
          $contributionOnPage = $contributionOnPage.replaceWith(responseNode);
        } else {
          $contributionOnPage = $target.append(responseNode);
        }
        $contributionOnPage.find('.rate-form-container').hide();
        return $contributionOnPage;
      },
      
      applyEasyTabsToTabStrip: function() {
        var $container = this,
            $tabs = $container.find('.tab-strip-options'),
            $inputs = $container.find('label,textarea'),
            $textareas = $inputs.filter('textarea');
            
        $inputs.each(function() {
          var $this = $(this),
              horizontalPadding = parseFloat($this.css('paddingLeft')) + parseFloat($this.css('paddingRight')),
              horizontalBorder = $this.outerWidth() - $this.innerWidth();

          $this.width( $container.innerWidth() - $tabs.outerWidth() - horizontalPadding - horizontalBorder - 2 );
        });
        $textareas.each(function() {
          var $this = $(this),
            verticalPadding = parseFloat($this.css('paddingTop')) + parseFloat($this.css('paddingBottom')),
            verticalBorder = $this.outerWidth() - $this.innerWidth(),
            $sibling = $(this).siblings('label').first(),
            extraVerticalSpace = 0;
          
          if ( $sibling.size() > 0 ) {
            extraVerticalSpace = $sibling.outerHeight();
          }
            
          $this.height( $tabs.outerHeight() - verticalPadding - verticalBorder - extraVerticalSpace );
        });
        
        $container.easytabs({
          tabActiveClass: 'tab-active',
          tabActivePanel: 'panel-active',
          tabs: '> .tab-area > .tab-strip-options > ul > li',
          defaultTab: '.default-tab',
          animationSpeed: 250,
          updateHash: false
        })  
          .live("easytabs:after", function(){
            $.colorbox.resize();
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
          $(this).find(".validation-error").html(errorString);
          $.colorbox.resize();
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
    			$(this).data('expanded', true);
    			$(target).slideDown();
    		}, 
    		function(){
    			$(this).text($(this).data('origText'));
    			$(this).data('expanded', false);
    			$(target).slideUp();
    		}
    	);
    }
    
  	$('a.conversation-action')
  	  .live("ajax:loading", function(){
  	    var href = $(this).attr("href"),
  	        label = href.match(/\/conversations\/node_conversation/) ? "Loading responses..." : "Loading...";
  	        
  	    $(this).data('origText', $(this).text());
  	    $(this).data('cancelText', href.match(/\/conversations\/node_conversation/) ? 'Hide responses' : 'Cancel');
  	    
  	    $(this).text(label);
  	  })
  	  .live("ajax:success", function(evt, data, status, xhr){
  	    var clicked = this,
  	        target = this.getAttribute("data-target"),
  	        tabStrip = target+" .tab-strip",
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
          var clicked = this,
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
              if( $(this).data('jquery-form-submitted') == true ) {
                var responseNode = $($("<div />").html(xhr.responseText).text()); // this is needed to properly unescape the HTML returned from doing the jquery.form plugin's ajaxSubmit for some reason
              } else {
                var responseNode = $(xhr.responseText);            
              }
              contributionContent = $(responseNode).html();
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
          $.colorbox.resize();
        },
        scrolling: false
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