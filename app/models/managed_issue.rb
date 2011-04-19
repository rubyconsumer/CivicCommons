class ManagedIssue < Issue

  has_one :index_page, :class_name => 'ManagedIssuePage'
  
  validates_presence_of :name
  
  validates_uniqueness_of :name

end
