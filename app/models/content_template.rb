class ContentTemplate < ActiveRecord::Base

  acts_as_revisionable :on_update => true

  belongs_to :author, :foreign_key => 'person_id', :class_name => 'Person'

  validates_presence_of :name, :template, :author
  validates_uniqueness_of :name

  has_friendly_id :name, :use_slug => true, :strip_non_ascii => true

end
