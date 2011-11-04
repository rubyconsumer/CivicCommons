require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminNewSurveyPage < PageObject

  def path
    '/admin/surveys/new'
  end
  
  def click_create_survey
    @page.click_link_or_button 'Create Survey'
  end
  
  def fill_in_survey_fields
    @page.fill_in(:title, :with => 'Title here')
    select_date('end_date', 1.week.from_now.to_date)
  end

  def select_date(field, date)
    @page.select date.to_time.strftime("%B"), :from => "survey[#{field}(2i)]"
    @page.select date.day.to_s, :from => "survey[#{field}(3i)]"
    @page.select date.year.to_s, :from => "survey[#{field}(1i)]"
  end
  
end
