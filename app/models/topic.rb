class Topic < ActiveRecord::Base
  has_and_belongs_to_many :issues, uniq: true

  has_and_belongs_to_many :radioshows,
    class_name: 'ContentItem',
    conditions: 'content_type = "RadioShow"',
    uniq: true

  has_and_belongs_to_many :blogposts,
    class_name: 'ContentItem',
    conditions: 'content_type = "BlogPost"',
    uniq: true

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :including_public_issues,
    joins(:issues).
      select('topics.*,count(issues.id) AS issue_count').
      where(:issues=>{:exclude_from_result => false,:type => 'Issue'}).
      group('topics.id').having('count(issues.id) > 0')

  # Issue with conditions on joins: https://github.com/rails/rails/issues/2637
  # The conditions are incorrectly used as ON parameters for the JOIN instead of WHERE clause
  #
  # Would have rather done something like:
  #
  #   joins(:radioshows).
  #     select('topics.*, count(content_items_topics.topic_id) AS radioshow_count').
  #     group('content_items_topics.topic_id')
  #
  scope :including_public_radioshows,
    joins('INNER JOIN `content_items_topics` ON `content_items_topics`.`topic_id` = `topics`.`id`').
      joins('INNER JOIN content_items ON content_items_topics.content_item_id = content_items.id').
      select('topics.*, count(content_items_topics.topic_id) AS radioshow_count').
      where('content_items.content_type = "RadioShow"').
      group('content_items_topics.topic_id')
end
