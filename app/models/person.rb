class Person < ActiveRecord::Base

  include Regionable
  include GeometryForStyle
  include Marketable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  attr_accessor :skip_shadow_account, :organization_name, :send_welcome, :skip_invite

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :first_name, :last_name, :email, :password, :password_confirmation, :top, :zip_code, :admin, :validated,
                  :avatar, :organization_name, :invite, :invite_attributes

  has_one :invite
  accepts_nested_attributes_for :invite

  has_many :contributions, :foreign_key => 'owner', :uniq => true
  has_many :ratings
  has_many :subscriptions
  has_and_belongs_to_many :conversations, :join_table => 'conversations_guides', :foreign_key => :guide_id

  has_many :contributed_conversations, :through => :contributions, :source => :conversation, :uniq => true
  has_many :contributed_issues, :through => :contributions, :source => :issue, :uniq => true

  validates_length_of :email, :within => 6..255, :too_long => "please use a shorter email address", :too_short => "please use a longer email address"
  validate :zip_code, :length => 10

  # Ensure format of salt
  validates_with PasswordSaltValidator

  has_attached_file :avatar,
    :styles => {
      :small => "20x20#",
      :medium => "40x40#",
      :standard => "70x70#",
      :large => "185x185#"},
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :default_url => '/images/avatar_70.gif',
    :path => ":attachment/:id/:style/:filename"

  validates_attachment_content_type :avatar,
                                    :content_type => %w(image/jpeg image/gif image/png image/jpg image/x-png image/pjpeg),
                                    :message => "Not a valid image file."
  process_in_background :avatar

  def avatar_exists
    self.avatar.exists?
  end

  scope :participants_of_issue, lambda{ |issue|
      joins(:conversations => :issues).where(['issue_id = ?',issue.id]).select('DISTINCT(people.id),people.*') if issue
    }

  scope :real_accounts, where("proxy is not true")
  scope :proxy_accounts, where(:proxy => true)
  scope :confirmed_accounts, where("confirmed_at is not null")
  scope :unconfirmed_accounts, where(:confirmed_at => nil)

  before_create :check_and_populate_invite, :unless => :skip_invite
  after_create :create_shadow_account, :unless => :skip_shadow_account
  after_create :notify_civic_commons
  before_save :check_to_send_welcome_email
  after_save :send_welcome_email, :if => :send_welcome?
  after_destroy :delete_shadow_account, :unless => :skip_shadow_account

  def newly_confirmed?
    confirmed_at_changed? && confirmed_at_was.blank? && !confirmed_at.blank?
  end

  def check_to_send_welcome_email
    @send_welcome = true if newly_confirmed?
  end

  def check_and_populate_invite
    if validate_invite_token(invite.invitation_token)
      invite.email = self.email
      invite.valid_invite = true
    else
      raise ActiveRecord::RecordNotSaved
    end
  end

  def validate_invite_token(token)
    token =~ /([a-zA-Z]{3})([0-9]{4})/i
  end

  def create_shadow_account
    begin
      Rails.logger.info("Creating shadow account for user with email #{email}")
      self.organization_name.blank?
        pa_person = PeopleAggregator::Person.create(id:                         id,
                                                    firstName:                  first_name,
                                                    lastName:                   last_name,
                                                    login:                      email,
                                                    password:                   encrypted_password,
                                                    email:                      email,
                                                    profilePictureWidth:        avatar_width_for_style(:large),
                                                    profilePictureHeight:       avatar_height_for_style(:large),
                                                    profilePictureURL:          avatar_url_without_timestamp(:large),
                                                    profileAvatarWidth:         avatar_width_for_style(:standard),
                                                    profileAvatarHeight:        avatar_height_for_style(:standard),
                                                    profileAvatarURL:           avatar_url_without_timestamp(:standard),
                                                    profileAvatarSmallWidth:    avatar_width_for_style(:medium),
                                                    profileAvatarSmallHeight:   avatar_width_for_style(:medium),
                                                    profileAvatarSmallURL:      avatar_url_without_timestamp(:medium))


    rescue PeopleAggregator::Error => e
      errors.add(:person, e.message)
      raise ActiveRecord::RecordNotSaved
    end


    save_pa_identifier(pa_person)
  end

  # Handles updating only certain fields exposed via the api
  # example hash of params would be
  # { :name => "John Foo",
  #   :email => "johnfoo@example.com",
  #   :zip_code => "60600",
  #   :avatar => {
  #     :content_type => "image/jpeg",
  #     :file_name => "test.jpeg",
  #     :file_size => 1000,
  #     :url => "http://some_amazon_s3_url"
  #   },
  #   :encrypted_password => "XXXXXXXXXXXX",
  #   :password_salt => "$2a$10$95c0ac175c8566911bb039$"
  # }
  #
  def api_update(params)
    params ||= {}

    # encrypted password is a protected attribute, explicitly update it if
    # it was changed
    _encrypted_password = params.delete(:encrypted_password)
    _password_salt = params.delete(:password_salt)
    if _encrypted_password && _password_salt
      if _password_salt.ends_with?("$")
        _password_salt.chop!
      end
      self.encrypted_password = _encrypted_password
      self.password_salt = _password_salt
    end

    # Handle updating the avatar
    if (avatar_params = params[:avatar]) && avatar_params.any?
      if url = avatar_params[:url]
        Rails.logger.info("New avatar url for Person #{self.id}\n #{url}")
      end

      # loop through all the attributes required by paperclip to circumvent
      # requesting the file from AWS. Slight hack around the way paper clip works
      required_attrs = [:file_name, :content_type, :file_size]
      required_attrs.each do |attr|
        self.send("avatar_#{attr}=", avatar_params[attr])
      end
      self.avatar_updated_at = Time.now
    end

    update_attributes(params)
  end

  def reset_password!(new_password, new_password_confirmation)
    if super
      PeopleAggregator::Account.update(self.people_aggregator_id,
                                       password: self.encrypted_password)
    end
  end

  def avatar_width_for_style(style)
    geometry_for_style(style, :avatar).width.to_i
  end

  def avatar_height_for_style(style)
    geometry_for_style(style, :avatar).height.to_i
  end


  def delete_shadow_account
    Rails.logger.info("Deleting shadow account for user with email #{email}")

    pa_person = PeopleAggregator::Person.find_by_email(self.email)
    pa_person.destroy

  end

  def name=(value)
    @name = value
    self.first_name, self.last_name = self.class.parse_name(value)
  end

  def name
    @name ||= ("%s %s" % [self.first_name, self.last_name]).strip
  end

  def notify_civic_commons
    Notifier.new_registration_notification(self).deliver
  end

  def send_welcome?
    @send_welcome
  end

  def send_welcome_email
    Notifier.welcome(self).deliver
    @send_welcome = false
  end

  def self.find_all_by_name(name)
    first, last = parse_name(name)
    where(:first_name => first, :last_name => last)
  end

  # Takes a full name and return an array of first and last name
  # Examples
  #  "Wendy" => ["Wendy", ""]
  #  "Wendy Smith" => ["Wendy", "Smith"]
  #  "Wendy van Buren" => ["Wendy", "van Buren"]
  #
  def self.parse_name(name)
    first, *last = name.split(' ')
    last = last.try(:join, " ") || ""
    return first, last
  end

  def create_proxy
    self.email = (first_name + last_name).gsub(/['\s]/,'').downcase + "@example.com"
    self.password = 'p4s$w0Rd'
    self.proxy = true
    @skip_invite = true
  end

  def subscriptions_include?(subscribable)
    subscriptions.map(&:subscribable).include?(subscribable)
  end

  def avatar_url_without_timestamp(style='')
    self.avatar.url(style).gsub(/\?\d+$/, '')
  end

  # Implement Marketable method
  def is_marketable?
    return false if skip_email_marketing

    newly_confirmed? ? true : false
  end

  # Implement Marketable method
  def subscribe_to_marketing_email
    h = Hominid::Base.new({:api_key => Civiccommons::Config.mailer_api_token})
    h.delay.subscribe(Civiccommons::Config.mailer_list, email, {:FNAME => first_name, :LNAME => last_name}, {:email_type => 'html'})
    Rails.logger.info("Success. Added mailing list subscription of #{name} to queue.")
  end

  private

  def save_pa_identifier(pa_person)
    Rails.logger.info("Success.  Person created.  Updating Person with People Agg ID...")
    self.people_aggregator_id = pa_person.id
    self.save
  end
end
