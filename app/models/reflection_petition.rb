class ReflectionPetition < ActiveRecord::Base
  belongs_to :reflection
  belongs_to :petition
  validates_presence_of :reflection_id, :petition_id
end
