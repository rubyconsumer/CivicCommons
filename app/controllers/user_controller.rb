class UserController < ApplicationController

  def edit
  end

  def show
    @user = Person.includes(:contributions, :subscriptions).find(params[:id])

    @contributions = @user.contributions.collect do |contribution|
      ContributionPresenter.new(contribution)
    end
    @contributions = @contributions.paginate(page: params[:page], per_page: 6)

    @issue_subscriptions = @user.subscriptions.select do |subscription|
      subscription.subscribable_type == "Issue"
    end

    @conversation_subscriptions = @user.subscriptions - @issue_subscriptions
  end

  def update
  end

end
