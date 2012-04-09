FactoryGirl.define do
  factory :survey_response do |f|
    f.association :person, :factory => :registered_user
    f.association :survey, :factory => :vote
  end

  factory :vote_survey_response,:class=>SurveyResponse do |f|
    f.association :person, :factory => :registered_user
    f.association :survey, :factory => :vote
  end
end