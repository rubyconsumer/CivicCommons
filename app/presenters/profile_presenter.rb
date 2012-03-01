class ProfilePresenter < Delegator
  Rails.application.routes.url_helpers
  PER_PAGE = 10

  def initialize(user, params={})
    @user = user
    @page = params.fetch(:page, 1)
  end

  def profile_data
    data = {}
    data[:address] = address if address.present?
    if organization_detail
      data[:phone] = organization_detail.phone if organization_detail.phone.present?
      data[:facebook] = organization_detail.facebook_page if organization_detail.facebook_page.present?
    end
    data[:email] = email if email.present? and is_organization?
    data[:website] = website if website.present?
    data[:twitter] = twitter_username if twitter_username.present?
    data
  end

  def __getobj__
    @user
  end

  def has_issue_subscriptions?
    not issue_subscriptions.empty?
  end

  def issue_subscriptions
    @user.subscribed_issues.first(PER_PAGE)
  end

  def has_conversation_subscriptions?
    not conversation_subscriptions.empty?
  end

  def conversation_subscriptions
    @user.subscribed_conversations.first(10)
  end

  def organization_subscriptions
    @user.subscribed_organizations.first(10)
  end

  def all_recent_activity
    @user.most_recent_activity
  end

  def recent_activity
    require 'will_paginate/array'
    @user.most_recent_activity.paginate(page: @page, per_page: PER_PAGE)
  end

  def has_profile?
    has_website? || has_twitter? || has_address? || has_email?
  end

  def title
    @user.title if !@user.is_organization?
  end

  def has_recent_activities?
    not recent_activity.empty?
  end
  def feed_path
    user_path(@user.cached_slug, format: :xml)
  end
  def feed_title
    "#{@user.name} at The Civic Commons"
  end

  def prompt_to_fill_out_bio? user
    user == @user and !bio.present?
  end

  def possessive_pronoun
    is_organization? ? "Our" : "My"
  end

  def action_phrase
    is_organization? ? "We Are" : "I Am"
  end
  def website
    if @user.website.present? && !@user.website.match(/^http/)
      "http://#{@user.website}"
    else
      @user.website
    end
  end

  def has_email?
    @user.email if is_organization?
  end

  private
  def address
    return "" unless has_address?
    """#{organization_detail.street}
      #{organization_detail.city}, #{organization_detail.region} #{organization_detail.postal_code}"""
  end


  def has_address?
    organization_detail != nil and organization_detail.present? and organization_detail.has_address?
  end
end
