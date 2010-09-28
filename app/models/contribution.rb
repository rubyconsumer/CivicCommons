require 'parent_validator'

class Contribution < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  acts_as_nested_set
  
  belongs_to :person, :foreign_key => "owner"
  belongs_to :conversation
  belongs_to :issue
  
  validates_with ContributionValidator
  validates :person, :conversation, :presence=>true 
  validates_associated :conversation, :parent, :person
  
  scope :most_recent, {:order => 'created_at DESC'}
  scope :not_top_level, where("type != 'TopLevelContribution'")
  scope :without_parent, where(:parent_id => nil)
    
  def self.create_node_level_contribution(params, person)
    model = params.delete(:type).constantize
    # could probably do this much cleaner, but still need to sanitize this for now
    raise(ArgumentError, "not a valid node-level Contribution type") unless [Answer,AttachedFile,Comment,EmbeddedSnippet,Link,Question,SuggestedAction].include?(model)
    params.merge!({:person => person})
    return model.create(params)
  end
      
end