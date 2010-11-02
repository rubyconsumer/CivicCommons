Given /^I have contributed a comment:$/ do |content|

  # TODO: Replace Date.parse with Chronic.parse
  Factory.create(:comment,
                 content: content,
                 person: @current_person,
                 conversation: @conversation,
                 created_at: Date.parse("2010/10/10"))
end

