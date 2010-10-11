module Civiccommons
  class PeopleAggregator
    PA_CONFIG = YAML.load_file(File.join(Rails.root, "config", "people_aggregator.yml"))
    
    cattr_accessor :URL, :admin_password
    
    @@URL ||= PA_CONFIG[Rails.env]['url']
    @@admin_password ||= PA_CONFIG[Rails.env]['admin_password']

  end
end
