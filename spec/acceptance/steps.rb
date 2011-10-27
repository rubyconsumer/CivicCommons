def given_i_am_logged_in_as_admin
  login_as_admin
end

def given_an_existing_topic
  create_topic name: 'Topic Name Here'
end

def when_i_create_an_issue_without_a_topic
  goto :admin_page
  follow_add_issue_link
  fill_name_with "The ultimate issue"
  attach_image 'imageAttachment.png'
  fill_summary_with 'OF ULTIMATE DESTINY'
  submit_issue
end

def when_i_create_an_issue_with_topics
  create_topic name: 'A Distinct Lack of Bacon' 
  goto :admin_page
  follow_add_issue_link
  
  fill_name_with "The ultimate issue"
  attach_image 'imageAttachment.png'
  fill_summary_with 'OF ULTIMATE DESTINY'
  select_topic 'A Distinct Lack of Bacon'
  submit_issue

end

def then_it_has_the_topics_i_assigned
  Issue.last.should have_topic 'A Distinct Lack of Bacon'
end

def then_i_am_reminded_to_add_topics
  add_topics_reminder.should be_visible
end


def when_i_create_a_topic
  login_as_admin
  follow_topics_link
  follow_new_topic_link
  submit_a_topic
end

def when_i_delete_a_topic
  login_as_admin
  follow_topics_link
  delete topic
end

def then_the_topic_should_no_longer_be_listed

  topic.should_not exist
  topic.should_not be_visible
end


def then_i_am_sent_to_the_topics_show_page
  current_page.should be_admin_page_for topic_i_just_created
end
