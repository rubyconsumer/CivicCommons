When /am on the conversation page$/ do

  @conversation = Factory.create(:conversation)
  Factory.create(:top_level_contribution,
                 conversation: @conversation)

  visit '/conversations/%s' % @conversation.id

end
