class ContentTemplate < ActiveRecord::Base
  extend FriendlyId

  acts_as_revisionable :on_update => true

  belongs_to :author, :foreign_key => 'person_id', :class_name => 'Person'

  validates_presence_of :name, :template, :author
  validates_uniqueness_of :name

  friendly_id :name, :use => :slugged
  def should_generate_new_friendly_id?
    new_record? || slug.nil?
  end

end
