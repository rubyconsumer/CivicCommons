module Civiccommons
  class PeopleAggregator
    URL = if Rails.env == "test" || Rails.env == "development" || Rails.env == "staging"
      "http://civiccommons.digitalcitymechanics.com"
    else
      "http://social.theciviccommons.com"
    end
  end
end
