$LOAD_PATH << "."
require 'rspec-spies'
require 'delegate'
require 'app/presenters/profile_presenter'

describe ProfilePresenter do

  let(:most_recent_activity) { stub(paginate: [1,2,3]) }
  let(:subscribed_issues) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] }
  let(:subscribed_conversations) { [:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k] }
  let(:user) do
    stub subscribed_issues: subscribed_issues,
      subscribed_conversations: subscribed_conversations,
      most_recent_activity: most_recent_activity
  end
  let(:presenter) { ProfilePresenter.new(user, page: 1) }

  it "reverses the order of subscribed issues" do
    presenter.issue_subscriptions.should == subscribed_issues.reverse[0..9]
  end

  it "reverses the order of subscribed conversations" do
    presenter.conversation_subscriptions.should == subscribed_conversations.reverse[0..9]
  end

  it "paginates recent activities" do
    presenter.recent_activity
    most_recent_activity.should have_received(:paginate).with(page: 1, per_page: 10)
  end

  it "has recent activities" do
    presenter.should have_recent_activities
  end

  it "has issue subscriptions" do
    presenter.should have_issue_subscriptions
  end

  it "has conversation subscriptions" do
    presenter.should have_conversation_subscriptions
  end

end
