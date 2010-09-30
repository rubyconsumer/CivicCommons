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
      var issue = $(this).parent("." + type);
      issue.append(form);
      form.show();
      clearHiddenFields();
      var idElement = $("#contribution_" + type + "_id");
      idElement.val(issue.attr("data-" + type + "_id")); 
      if (!idElement.val()) { console.log("couldn't attach " + type + " id");}
      console.log(idElement.val());
    };
  };

  var self = {};
  self.init = function() {
    $(".issue a").click(handleLinkClick("issue"));
    $(".conversation a").click(handleLinkClick("conversation"));
    $(".tab-strip").easyTabs();
  };
  return self;
}();
$(link.init);
