class SurveyResponse < ActiveRecord::Base
  has_many :selected_survey_options, :dependent => :destroy
  belongs_to :person
  belongs_to :survey
  validates_presence_of :person_id
  after_create :send_survey_confirmation
  
  def send_survey_confirmation
    Notifier.survey_confirmation(person, survey).deliver
  end
end