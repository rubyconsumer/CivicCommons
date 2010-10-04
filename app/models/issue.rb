class Issue < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  
  belongs_to :person

  has_and_belongs_to_many :conversations
  # Contributions directly related to this Issue
  has_many :contributions
  has_many :comments
  has_many :suggested_actions
  has_many(:media_contributions, :class_name => "Contribution",
           :conditions => "type = 'Link' or type = 'AttachedFile'")
  
  
  # Anyone who has contributed directly to the issue via a contribution
  has_many(:participants,
           :through => :contributions,
           :source => :person,
           :uniq => true)
  
  # paperclip bug: if you don't specify the path, you will get
  # a stack overflow when trying to upload an image.
  # return an open File object that contains our Amazon S3 credentials.
  filename = '/data/TheCivicCommons/shared/config/amazon_s3.yml' # the way it lands on EngineYard
  filename = Rails.root + 'config/amazon_s3.yml' unless File.exist? filename
  s3_credential_file = File.new(filename)

  has_attached_file(:image,
                    :styles => {
                      :thumb => "100x100#",
                      :small => "150x150>",
                      :normal => "480x300>",
                      :panel => "198x130>" },
                    :storage => :s3,
                    :s3_credentials => s3_credential_file,
                    :path => ":attachment/:id/:style/:filename",
                    :default_url => '/images/issue_img_:style.gif')


  validates :name, :presence => true, :length => { :minimum => 5 }  
  
  scope(:most_active, :select =>
        'count(1) as contribution_count, issues.*',
        :joins => [:contributions],
        :group => "issues.id",
        :order => 'contribution_count DESC')
  
  scope :most_recent, {:order => 'created_at DESC'}
  scope :most_recent_update, {:order => 'updated_at DESC'}
  scope :alphabetical, {:order => 'name ASC'}
  scope :sort, lambda { |sort_type|
      case sort_type
      when 'most_recent'
        most_recent
      when 'alphabetical'
        alphabetical
      when 'most_recent_update'
        most_recent_update
      when 'most_active'
        most_active
      end
    }
  
end
