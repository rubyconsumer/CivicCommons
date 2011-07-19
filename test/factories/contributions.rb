Factory.define :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.top_level false
  f.parent nil
  f.association :conversation, :factory => :conversation
  f.content "Basic Contributions"
  f.override_confirmed true
  f.url nil
end

Factory.define :top_level_contribution, :parent => :contribution do |f|
  f.top_level true
end

Factory.define :contribution_without_parent, :parent => :contribution do |f|
  f.top_level false
  f.parent nil
end

Factory.define :issue_contribution, :parent => :contribution do |f|
  f.conversation nil
  f.association :issue, :factory => :issue
  f.parent nil
end

Factory.define :comment, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Basic Comment"
end

Factory.define :comment_with_unique_content, :parent => :comment do |f|
  f.sequence(:content) {|n| "Test Comment #{n}" }
end

Factory.define :suggested_action, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Suggested Action Contribution"
end

Factory.define :question, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Question Contribution"
end

Factory.define :question_without_parent, :parent => :question do |f|
  f.parent nil
end

Factory.define :answer, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :question, :override_confirmed => true
  f.conversation { |c| c.parent.conversation }
  f.content "Answer Contribution"
end

Factory.define :attached_file, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Attached File Contribution"
  f.attachment File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
end

Factory.define :link, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Link Contribution"
  f.url "http://www.example.com/this-page-exists"
  f.embedly_type "video"
  f.embedly_code "valid embedly code"
end

Factory.define :embedded_snippet, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Embedded Snippet Contribution"
  f.url "http://www.youtube.com/watch?v=djtNtt8jDW4"
  f.embedly_type "video"
  f.embedly_code "valid embedly code"
end

Factory.define :embedly_contribution, :parent => :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :conversation, :factory => :conversation
  f.association :parent, :factory => :top_level_contribution
  f.content "Embedly Contribution"
  f.url "http://www.youtube.com/watch?v=djtNtt8jDW4"
  f.embedly_type "video"
  f.embedly_code "valid embedly code"
end
