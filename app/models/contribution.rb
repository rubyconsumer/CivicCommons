require 'parent_validator'

class Contribution < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  acts_as_nested_set
  
  ALL_TYPES = ["Answer","AttachedFile","Comment","EmbeddedSnippet","Link",
               "Question","SuggestedAction", "PplAggContribution"]
  
  belongs_to :person, :foreign_key => "owner"
  belongs_to :conversation
  belongs_to :issue
  
  validates_with ContributionValidator
  validates :item, :presence=>true 
  validates :person, :must_be_logged_in => true
  # validates_associated :conversation, :parent, :person # <= these probably aren't really needed here
  
  scope :most_recent, {:order => 'created_at DESC'}
  scope :not_top_level, where("type != 'TopLevelContribution'")
  scope :without_parent, where(:parent_id => nil)
  scope :confirmed, where(:confirmed => true)
  scope :unconfirmed, where(:confirmed => false)
  
  before_create :set_confirmed
  
  attr_accessor :override_confirmed
  
  def self.update_or_create_node_level_contribution(params,person)
    if contribution = Contribution.unconfirmed.where(:type => params[:type], :parent_id => params[:parent_id], :owner => person.id).first
      contribution.update_attributes(params)
    else 
      contribution = Contribution.create_node_level_contribution(params,person)
    end
    return contribution
  end
  
  def self.new_node_level_contribution(params, person)
    model, params = setup_node_level_contribution(params,person)
    model.new(params)
  end
  
  def self.create_node_level_contribution(params, person)
    model, params = setup_node_level_contribution(params,person)
    contribution = model.create(params)
  end
  
  def self.create_confirmed_node_level_contribution(params, person)
    params.merge!(:override_confirmed => true)
    create_node_level_contribution(params, person)
  end
  
  def self.delete_old_unconfirmed_contributions
    count = self.unconfirmed.where(["created_at < ?", 1.day.ago]).count
    self.unconfirmed.destroy_all(["created_at < ?", 1.day.ago])
    return count
  end

  def item=(item)
    if item.is_a?(Conversation)
      self.conversation = item
    elsif item.is_a?(Issue)
      self.issue = item
    end
  end
 
  def item
    self.conversation || self.issue
  end

  # Is this contribution an Image? Default to false, override in
  # subclasses
  def is_image?
    false
  end
  
  def confirm!
    self.update_attribute(:confirmed, true)
  end
  
  def destroy_by_user(user)
    if self.editable_by?(user)
      self.destroy
    else
      self.errors[:base] << "Contributions cannot be deleted if they are older than 30 minutes or have any responses."
      return false
    end
  end
  
  def update_attributes_by_user(params, user)
    params = params.select{ |k,v| [:content, :url].include?(k) }
    if self.editable_by?(user)
      self.update_attributes(params)
    else
      self.errors[:base] << "Contributions cannot be edited if they are older than 30 minutes or have any responses."
      return false
    end
  end
  
  def editable_by?(user)
    (user.admin? || (self.owner == user.id && self.created_at > 30.minutes.ago)) && self.descendants.count == 0
  end
  
  protected
  
  def self.setup_node_level_contribution(params,person)
    model = params.delete(:type).constantize
    # could probably do this much cleaner, but still need to sanitize this for now
    raise(ArgumentError, "not a valid node-level Contribution type") unless ALL_TYPES.include?(model.to_s)
    params.merge!({:person => person})
    return model,params
  end
  
  def override_confirmed?
    self.override_confirmed
  end
  
  def top_level_contribution?
    self.class == TopLevelContribution
  end
  
  def set_confirmed
    self.confirmed = self.override_confirmed? || self.top_level_contribution? ? true : 0
    # RAILS BUG - ActiveRecord::RecordNotSaved if set to false, but works for true, 1, and 0
  end

end
