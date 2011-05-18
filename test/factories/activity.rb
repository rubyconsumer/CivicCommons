Factory.define :activity do |activity|
  activity.item_id 1
  activity.item_type 'Conversation'
  activity.item_created_at Time.now
end

Factory.define :conversation_activity, parent: :activity do |activity|
  activity.item_id 1
  activity.item_type 'Conversation'
  activity.item_created_at Time.now
end

Factory.define :issue_activity, parent: :activity do |activity|
  activity.item_id 1
  activity.item_type 'Issue'
  activity.item_created_at Time.now
end

Factory.define :contribution_activity, parent: :activity do |activity|
  activity.item_id 1
  activity.item_type 'Contribution'
  activity.item_created_at Time.now
end

Factory.define :rating_group_activity, parent: :activity do |activity|
  activity.item_id 1
  activity.item_type 'RatingGroup'
  activity.item_created_at Time.now
end

