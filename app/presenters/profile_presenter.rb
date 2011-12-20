class ProfilePresenter < Delegator
  include Rails.application.routes.url_helpers
  PER_PAGE = 10

  def initialize(user, params={})
    @user = user
    @page = params.fetch(:page, 1)
  end

  def __getobj__
    @user
  end

  def issue_subscriptions
    @user.subscribed_issues.reverse.first(PER_PAGE)
  end

  def has_issue_subscriptions?
    not issue_subscriptions.empty?
  end

  def conversation_subscriptions
    @user.subscribed_conversations.reverse.first(10)
  end

  def has_conversation_subscriptions?
    not conversation_subscriptions.empty?
  end

  def all_recent_activity
    @user.most_recent_activity
  end

  def recent_activity
    @user.most_recent_activity.paginate(page: @page, per_page: PER_PAGE)
  end

  def has_profile?
    has_website? || has_twitter?
  end

  def has_recent_activities?
    not recent_activity.empty?
  end
  def feed_path
    user_path(@user, format: :xml)
  end
  def feed_title
    "#{@user.name} at The Civic Commons"
  end
  def prompt_to_fill_out_bio? user
    user == @user and bio.empty?
  end
end
