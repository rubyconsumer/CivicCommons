# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :top_level_contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :conversation, :factory => :conversation
  f.content "MyText"
  f.type "TopLevelContribution"
end

Factory.define :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Basic Contributions"
  f.override_confirmed true
end

Factory.define :contribution_without_parent, :parent => :contribution do |f|
  f.parent nil
end

Factory.define :issue_contribution, :parent => :contribution do |f|
  f.conversation nil
  f.association :issue, :factory => :issue
  f.parent nil
end

Factory.define :comment do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Basic Comment"
end

Factory.define :comment_with_unique_content, :parent => :comment do |f|
  f.sequence(:content) {|n| "Test Comment #{n}" }
end

Factory.define :suggested_action do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Suggested Action Contribution"
end

Factory.define :question do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Question Contribution"
end

Factory.define :question_without_parent, :parent => :question do |f|
  f.parent nil
end

Factory.define :answer do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :question, :override_confirmed => true
  f.conversation { |c| c.parent.conversation }
  f.content "Answer Contribution"
end

Factory.define :attached_file do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Attached File Contribution"
  f.attachment File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
end

Factory.define :link do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Link Contribution"
  f.url "http://www.example.com/this-page-exists"
end

Factory.define :embedded_snippet do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :parent, :factory => :top_level_contribution
  f.conversation { |c| c.parent.conversation }
  f.content "Embedded Snippet Contribution"
  f.url "http://www.youtube.com/watch?v=djtNtt8jDW4"
end

Factory.define :embedly_contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :person, :factory => :normal_person
  f.association :conversation, :factory => :conversation
  f.association :parent, :factory => :top_level_contribution
  f.content "Embedly Contribution"
  f.url "http://www.youtube.com/watch?v=djtNtt8jDW4"
  f.embedly_type "video"
  f.embedly_code "valid embedly code"
end
