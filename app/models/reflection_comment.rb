class ReflectionComment < ActiveRecord::Base
  belongs_to :reflection
  belongs_to :person
  validates_presence_of :body
end
