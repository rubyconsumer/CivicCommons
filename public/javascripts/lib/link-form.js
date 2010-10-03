var link = function() {

  var form, urlField, url, issueIdField, conversationIdField;

  var clearHiddenFields = function() {
    issueIdField.val('');
    conversationIdField.val('');
  };

  var handleLinkClick = function(type) {
    return function() {
      var issue = $(this).parents("." + type);
      issue.append(form);
      form.show();
      clearHiddenFields();
      var idElement = $("#contribution_" + type + "_id");
      idElement.val(issue.attr("data-" + type + "_id")); 
    };
  };

  var setupClosures = function() {
    urlField = $("#contribution_url");
    url = urlField.val();
    issueIdField = $("#contribution_issue_id"); 
    conversationIdField = $("#contribution_conversation_id");
    form = $("#link_form_wrapper").remove();
  };

  var self = {};
  
  self.init = function() {
    setupClosures();
    $(".issue .attach").click(handleLinkClick("issue"));
    $(".conversation .attach").click(handleLinkClick("conversation"));
    $(".tab-strip").easyTabs();
  };
  return self;
}();

var tabs = function() {
  var self = {};
  self.init = function() {
    $(".tab").hide();
    $(".tabs ul li").live("click", function() {
      $(".tab").hide();
      $("#" + $(this).attr("data-tab")).fadeIn(140);
    });
    $(".tabs ul li:first").click();
  };
  return self;
}();
$(tabs.init);
$(link.init);
