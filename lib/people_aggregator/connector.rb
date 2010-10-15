module PeopleAggregator::Connector
  extend ActiveSupport::Concern


  included do
    self.send(:include, HTTParty)
    self.send(:base_uri,
              "#{Civiccommons::PeopleAggregator.URL}/api/json.php")

  end


  module ClassMethods

    def log_people_aggregator_response(response)
      Rails.logger.info "Response from PeopleAggregator server:\n\tCode: %s\n\tBody: %p" %
        [response.code, response.body]
    end


    def log_people_aggregator_request(uri, request={})
      Rails.logger.info "Request to PeopleAggregator:\n\tURI: %s\n\tBody: %p" % [uri, request]
    end

  end


end
