module PeopleAggregator::Connector


  def self.included(klass)
    klass.send(:include, HTTParty)
  end


end
