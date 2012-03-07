class PetitionSignature < ActiveRecord::Base
  belongs_to :petition
  belongs_to :person
  validates_presence_of :petition_id, :person_id
end