module HelperMethods


  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end

  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end

  def fill_the_following(fields={})
    fields.each do |field, value|
      fill_in field,  :with => value
    end
  end
  
  def should_have_the_following(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end

  def should_have_table(table_name, *rows)
    within(table_name) do
      rows.each do |columns|
        columns.each { |content| page.should have_content(content) }
      end
    end
  end

  
  def clear_mail_queue
    ActionMailer::Base.deliveries.clear
  end

  def should_send_an_email(values={})
    mailing = ActionMailer::Base.deliveries.first
    mailing[:from].to_s.should == Civiccommons::Config.devise['email']
    mailing.to.should == [values['To']]
    mailing.subject.should == values['Subject']
  end

  def should_not_send_an_email
    ActionMailer::Base.deliveries.should be_empty
  end

end

RSpec::Matchers.define :exist_in_the_database do
  match do | actual | 
    actual.id != nil
  end
end
RSpec.configuration.include HelperMethods, :type => :acceptance
