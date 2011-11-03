module CivicCommonsDriver
  include Rails.application.routes.url_helpers
  @@available_pages = {}
  @@contributions = []
  @@current_page = nil
  @@user = nil
  def self.available_pages
    @@available_pages
  end

  def self.set_current_page_to page
    raise "OH NOES NO PAGE FOR #{page}" unless @@available_pages.has_key?(page)
    self.current_page = @@available_pages[page].new 
  end

  def set_current_page_to page
    CivicCommonsDriver.set_current_page_to page
  end

  def attachments_path
    File.expand_path(File.dirname(__FILE__) + '/attachments')
  end

  def create_user(type)
    Factory.create(type, declined_fb_auth: true)
  end

  def login_as(type = :person)
    self.user = create_user type 
    login logged_in_user
  end

  def goto screen
    set_current_page_to screen
    current_page.goto
  end

  def select_topic topic
    check topic  
  end


  def topic

    topic = Topic.find(@topic.id) if @topic.id!=nil and Topic.exists? @topic.id
    topic.instance_eval do
      def removed_from? page
        page.has_no_css? locator
      end

      def has_been_removed_from_the_database?
        !Topic.exists? id
      end

      def locator
        "tr[data-topic-id='#{id}']"
      end
    end
    topic
  end
  def goto_admin_page_as_admin
    login_as :admin
    goto :admin
  end
  def follow_topics_link
    click_link 'Topics'
    set_current_page_to :admin_topics
  end
  def self.current_page= page
    @@current_page = page
  end
  def current_page
    @@current_page
  end

  def follow_add_topic_link
    click_link 'Add Topic'
    self.current_page = Pages::Admin::Topics::Add.new
  end

  def fill_in_topic_form(options = { :name=>"WOOHOO!" })
    fill_in 'Name', :with => options[:name]
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
  def create_contributions_for conversation
    @@contributions << Factory.create(:contribution, :override_confirmed => true, :conversation => conversation, :parent=>contribution, :title=>"Another Contributioooon!")
  end

  def contribution= contribution
    @@contribution = contribution
  end
  def contributions
    @@contributions
  end
  def contribution
    @@contribution
  end
  def the_page_im_on
    def page.for_the?(topic)
      current_path.should == "/admin/topics/#{topic.id}"
    end
    def page.has_an_error?
      has_css? '#error_explanation'
    end
    page
  end
  class Database
    def has_any?(type)
      !Topic.count.zero? 
    end
    def create_topic(attributes={}) 
      Factory.create :topic, attributes
    end

    def create_issue(attributes= {})
      Factory.create :issue, attributes
    end
  end
  def database
    Database.new
  end

  def conversation
    @conversation = Conversation.find_by_title("Frank")
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
end


Rspec.configuration.include CivicCommonsDriver, :type => :acceptance
