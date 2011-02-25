module HelperMethods
  # Put helper methods you need to be available in all tests here.

  ###################################################################
  # http://blog.areacriacoes.com.br/2010/8/20/helpers-para-steak

  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end

  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end

  #fill_the_following(
  #  "Post"          => "Steak is awesome",
  #  "Publish date"  => "31/10/2010",
  #  "Excerpt"       => "Bla bla bla ...",
  #  "Body"          => "Bla bla bla ..."
  #)
  def fill_the_following(fields={})
    fields.each do |field, value|
      fill_in field,  :with => value
    end
  end

  #within(".tags") do
  #  should_have_the_following(
  #    'steak',
  #    'acceptance',
  #    'rails',
  #    'ruby'
  #  )
  #end
  def should_have_the_following(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end

  #should_have_table "#posts_grid",
  #  [ "Intro to RSpec", "Super awesome post about rspec..."     ],
  #  [ "Rails 3.0",      "Last week Rails 3.0RC was released..." ]
  def should_have_table(table_name, *rows)
    within(table_name) do
      rows.each do |columns|
        columns.each { |content| page.should have_content(content) }
      end
    end
  end

  ###################################################################
  
  def clear_mail_queue
    ActionMailer::Base.deliveries.clear
  end

  def should_send_an_email(values={})
    mailing = ActionMailer::Base.deliveries.first
    mailing[:from].to_s.should == Civiccommons::Config.devise_email
    mailing.to.should == [values['To']]
    mailing.subject.should == values['Subject']
  end

  def should_not_send_an_email
    ActionMailer::Base.deliveries.should be_empty
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
