class OrganizationController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
    @recent_items = @organization.most_recent_activity_items(page: params[:page], per_page: 10)
    @issue_subscriptions = @organization.subscribed_issues.reverse
    @issue_subscriptions = @organization.subscribed_conversations.reverse
  end
end
