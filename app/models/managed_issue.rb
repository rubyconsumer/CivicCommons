class ManagedIssue < Issue

  belongs_to :index,
    :class_name => 'ManagedIssuePage',
    :foreign_key => 'managed_issue_page_id',
    :readonly => true

  has_many :pages,
    :class_name => 'ManagedIssuePage',
    :foreign_key => 'issue_id',
    :dependent => :destroy,
    :readonly => true

  validate :index_is_a_circular_reference

private

  def index_is_a_circular_reference
    if index and (index.issue.nil? or id != index.issue.id)
      errors.add(:index, 'index page must be associated with this issue')
    end
  end

end
