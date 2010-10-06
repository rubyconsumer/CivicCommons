module Civiccommons
  class PeopleAggregator
    PA_CONFIG = YAML.load_file(File.join(Rails.root, "config", "people_aggregator.yml"))
    
    cattr_accessor :URL
    
    @@URL ||= PA_CONFIG[Rails.env]['url']

  end
end
