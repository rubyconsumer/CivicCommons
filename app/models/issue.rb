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
  
  validates :description, :presence => true, :length => { :minimum => 5 }  
  
  scope :most_recent, {:order => 'created_at DESC'}
  scope :most_recent_update, {:order => 'updated_at DESC'}
  scope :alphabetical, {:order => 'description ASC'}
  scope :sort, lambda { |sort_type|
      case sort_type
      when 'most_recent'
        most_recent
      when 'alphabetical'
        alphabetical
      when 'most_recent_update'
        most_recent_update
      end
    }
  
end
