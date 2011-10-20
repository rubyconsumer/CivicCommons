class ManagedIssuePage < ActiveRecord::Base

  acts_as_revisionable :on_update => true

  belongs_to :issue,
    :class_name => 'ManagedIssue',
    :foreign_key => 'issue_id',
    :readonly => true

  belongs_to :author,
    :foreign_key => 'person_id',
    :class_name => 'Person',
    :readonly => true

  has_one :index_for,
    :class_name => 'ManagedIssue',
    :foreign_key => 'managed_issue_page_id',
    :readonly => true

  validates_presence_of :name, :template, :issue, :author
  validates_uniqueness_of :name

  has_friendly_id :name, :use_slug => true, :strip_non_ascii => true

  searchable :ignore_attribute_changes_of => [ :updated_at, :stylesheet_path, :template ] do
    text :template, :stored => true, :boost => 1, :default_boost => 1 do
       CCML.sanitize_tags(template)
    end
  end
end
