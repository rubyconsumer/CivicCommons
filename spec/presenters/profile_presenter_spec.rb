$LOAD_PATH << "."
require 'spec/fast/helper.rb'
require 'delegate'
require 'app/presenters/profile_presenter'
describe ProfilePresenter do

  let(:most_recent_activity) { stub(paginate: [1,2,3]) }
  let(:subscribed_issues) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] }
  let(:subscribed_conversations) { [:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k] }
  let(:user) do
    stub subscribed_issues: subscribed_issues,
      subscribed_conversations: subscribed_conversations,
      most_recent_activity: most_recent_activity,
      cached_slug: "bob",
      name: "Bob"
  end
  let(:presenter) { ProfilePresenter.new(user, page: 1) }

  it "#has_issue_subscriptions?" do
    presenter.should have_issue_subscriptions
  end
  describe "#issue_subscriptions" do
    it "reverses the order" do
      presenter.issue_subscriptions.should == subscribed_issues.reverse[0..9]
    end
    it "limits to 10" do
      presenter.issue_subscriptions.length.should == 10
    end
  end
  it "#has_conversation_subscriptions?" do
    presenter.should have_conversation_subscriptions
  end
  describe "#conversation_subscriptions" do
    it "reverses the order" do
      presenter.conversation_subscriptions.should == subscribed_conversations.reverse[0..9]
    end
    it "limits to 10 items" do
      presenter.conversation_subscriptions.size.should == 10
    end
  end
  it "#has_recent_activities?" do
    presenter.should have_recent_activities
  end
  describe "#recent_activity" do
    it "is paginated" do
      presenter.recent_activity
      most_recent_activity.should have_received(:paginate).with(page: 1, per_page: 10)
    end
  end
  describe "#all_recent_activity" do
    it "is not paginated" do
      presenter.all_recent_activity
      most_recent_activity.should_not have_received(:paginate)
    end
  end
  describe "#feed_path" do
    it "is /user_path/user_slug.xml" do
      presenter.stub(:user_path) do |u, opts| 
        "/blarp/#{u.cached_slug}.#{opts[:format]}"
      end
      presenter.feed_path.should == "/blarp/bob.xml"
    end
  end
  describe "#feed_title" do
    it "is Name at The Civic Commons" do
      presenter.feed_title.should == "Bob at The Civic Commons"
    end
  end
end
