module CivicCommonsDriver
  include Database
  include Rails.application.routes.url_helpers
  @@available_pages = {}
  @@current_page = nil
  @@user = nil
  def self.available_pages
    @@available_pages
  end

  def self.set_current_page_to page, options={}
    return if page == :current
    raise "OH NOES NO PAGE FOR #{page}" unless @@available_pages.has_key?(page)
    self.current_page = @@available_pages[page].new options
  end

  def set_current_page_to page, options = {}
    CivicCommonsDriver.set_current_page_to page, options
  end

  def create_user(type)
    Factory.create(type, declined_fb_auth: true)
  end

  def login_as(type = :person)
    self.user = create_user type
    login logged_in_user
  end

  def goto screen, options={}
    set_current_page_to screen, options
    current_page.goto
  end


  def goto_admin_page_as_admin
    login_as :admin
    goto :admin
  end

  def current_page
    @@current_page
  end

  def topic_i_added
    Topic.last
  end

  def submitted_topic
    Topic.find_by_name "WOOHOO!"
  end

  def the_current_page
    current_page
  end

  def create_contribution options={}
    self.contribution = Factory.create(:contribution_without_parent, options)
  end

  def contribution= contribution
    @@contribution = contribution
  end

  def contribution
    @@contribution
  end

  def conversation
    Conversation.last
  end

  def user=(user)
    @@user =(user)
  end

  def logged_in_user
    @@user
  end

  def create_subcontribution_for contribution
    Factory.create(:contribution, :conversation=>contribution.conversation, :parent=> contribution)
  end

  def method_missing(method, *args, &block)
    if current_page and current_page.respond_to? method
      current_page.send(method, *args, &block)
    else
      super
    end
  end

  :private
  def login(user)
    goto :login
    fill_in_email_with user.email
    fill_in_password_with user.password
    click_login_button
  end

  def self.current_page= page
    @@current_page = page
  end
end


Rspec.configuration.include CivicCommonsDriver, :type => :acceptance
