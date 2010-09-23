class Issue < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  
  belongs_to :person
  has_and_belongs_to_many :conversations
  has_many :contributions
  
  def participants
    Person.participants_of_issue(self)
  end
  
  validates :name, :presence => true, :length => { :minimum => 5 }  
      
  scope :most_hot,
    :select => '(SELECT COUNT(contributions.id) FROM contributions WHERE (contributions.issue_id = issues.id)) + 
      (SELECT COUNT(DISTINCT(people.id)) FROM people INNER JOIN conversations_guides ON conversations_guides.guide_id = people.id INNER JOIN conversations ON conversations.id = conversations_guides.conversation_id INNER JOIN conversations_issues ON conversations_issues.conversation_id = conversations.id INNER JOIN issues ON issues.id = conversations_issues.issue_id WHERE (issue_id = issues.id)) 
      AS hotness, issues.*',  
    :order => 'hotness DESC'    
  
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
      when 'most_hot'
        most_hot
      end
    }
  
end
