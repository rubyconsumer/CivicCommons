class Topic < ActiveRecord::Base
  has_and_belongs_to_many :issues
  validates_presence_of :name
  validates_uniqueness_of :name
  scope :including_public_issues, 
    joins(:issues).
      select('topics.*,count(issues.id) AS issue_count').
      where(:issues=>{:exclude_from_result => false,:type => 'Issue'}).
      group('topics.id').having('count(issues.id) > 0')
end
