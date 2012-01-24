class ManagedIssuePage < ActiveRecord::Base
  include Rails.application.routes.url_helpers #needed by the url helper in this class

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
  validate :valid_ccml_tags

  has_friendly_id :name, :use_slug => true, :strip_non_ascii => true

  searchable :ignore_attribute_changes_of => [ :updated_at, :stylesheet_path, :template ] do
    text :template, :stored => true, :boost => 1, :default_boost => 1 do
      text = Sanitize.clean(template, :remove_contents => ['style','script'])
      CCML.sanitize_tags(text)
    end
    string :type do
      'ManagedIssuePage'
    end
  end

  def valid_ccml_tags
    if !self.template.blank? && !self.issue_id.blank?
      begin
        CCML.parse(self.template,
          issue_page_url((self.id || 'temporary-id'), :issue_id => issue_id, :host=>'localhost'), # need the url to properly parse it
          {:silence_external_source_errors => false})
      rescue => e
        self.errors.add(:template,"has a CCML tag error: #{e}" )
      end
    end
  end

end
