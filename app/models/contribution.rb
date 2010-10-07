require 'parent_validator'

class Contribution < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  acts_as_nested_set
  
  ALL_TYPES = ["Answer","AttachedFile","Comment","EmbeddedSnippet","Link","Question","SuggestedAction"]
  
  belongs_to :person, :foreign_key => "owner"
  belongs_to :conversation
  belongs_to :issue
  
  validates_with ContributionValidator
  validates :item, :presence=>true 
  validates_associated :conversation, :parent, :person
  
  scope :most_recent, {:order => 'created_at DESC'}
  scope :not_top_level, where("type != 'TopLevelContribution'")
  scope :without_parent, where(:parent_id => nil)
  
  scope :with_user_rating, lambda { |user|
    select("contributions.*, user_rating.rating as user_rating").
    joins("LEFT OUTER JOIN ratings AS user_rating ON user_rating.rateable_id = contributions.id AND user_rating.rateable_type = 'Contribution' AND user_rating.person_id = #{user.id}")
  }
    
  def self.create_node_level_contribution(params, person)
    model = params.delete(:type).constantize
    # could probably do this much cleaner, but still need to sanitize this for now
    raise(ArgumentError, "not a valid node-level Contribution type") unless ALL_TYPES.include?(model.to_s)
    params.merge!({:person => person})
    return model.create(params)
  end
     
  def item
    self.conversation || self.issue
  end

end
