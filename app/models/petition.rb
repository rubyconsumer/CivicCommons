class Petition < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'person_id'
  has_many :signatures, :class_name => 'PetitionSignature', :dependent => :destroy
  has_many :signers, :class_name => 'Person', :through => :signatures, :source => :person
  
  validates_presence_of :title, 
                        :description, 
                        :resulting_actions, 
                        :end_on, 
                        :signature_needed,
                        :person_id
  validates_numericality_of :signature_needed, :greater_than => 0, :allow_blank => true
  
end