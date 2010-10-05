var link = function() {
  var form = $("#link_form_wrapper").remove();
  var issueIdField = $("#contribution_issue_id"); 
  var conversationIdField = $("#contribution_conversation_id");

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

  var self = {};
  self.init = function() {
    $(".issue .attach").click(handleLinkClick("issue"));
    $(".conversation .attach").click(handleLinkClick("conversation"));
    $(".tab-strip").easyTabs();
  };
  return self;
}();
$(link.init);
