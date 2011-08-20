class Survey < ActiveRecord::Base
  SURVEY_TYPES = ['Vote', 'Poll']
  belongs_to :surveyable, :polymorphic => true
  has_many :options, :class_name => 'SurveyOption', :foreign_key => 'survey_id', :dependent => :destroy
  has_many :survey_responses, :dependent => :restrict
  validates_presence_of :max_selected_options, :title, :end_date
  validates_numericality_of :max_selected_options, :only_integer => true
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true
  
  def days_until_end_date
    (Date.today - end_date).to_i.abs if end_date && end_date.future?
  end
  
  def show_progress_now?
    show_progress? && (end_date.present? && end_date.past? )
  end
  
  def active?
    start_date.blank? || (start_date && start_date <= Date.today)
  end
end
