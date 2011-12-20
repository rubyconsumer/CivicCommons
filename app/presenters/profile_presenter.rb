class ProfilePresenter < Delegator

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

  def recent_activity
    @user.most_recent_activity.paginate(page: @page, per_page: PER_PAGE)
  end

  def has_recent_activities?
    not recent_activity.empty?
  end
end
