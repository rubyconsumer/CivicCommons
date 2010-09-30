var link = function() {
  var form = $("#link_form_wrapper").remove();
  var issueIdField = $("#link_issue_id"); 
  var conversationIdField = $("#link_conversation_id");

  var clearHiddenFields = function() {
    issueIdField.val('');
    conversationIdField.val('');
  };

  var handleLinkClick = function(type) {
    return function() {
      var issue = $(this).parent("." + type);
      clearHiddenFields();
      $("#link_" + type + "_id").val(issue.attr("data-" + type + "_id")); 
      form.hide().fadeIn(240);
      issue.append(form);
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
