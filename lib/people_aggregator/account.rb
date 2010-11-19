# Represents an account on People Aggregator
class PeopleAggregator::Account
  include PeopleAggregator::Connector
  include PeopleAggregator::ApiObject
  
  # update the user account on people aggregator
  # people_aggregator_id is the id field on peopleaggregator
  # attrs is a hash containing the fields to be updated
  def self.update(people_aggregator_id, attrs)
    if people_aggregator_id.nil?
      Rails.logger.info("Could not update account since password was nil")
      return
    end

    endpoint = '/peopleaggregator/editUser'
    
    body_params = attrs.merge(adminPassword: Civiccommons::PeopleAggregator.admin_password,
                              # homeNetwork is needed for PeopleAggregator compatability (see Parag)
                              homeNetwork: 'default',
                              id: people_aggregator_id)

    log_people_aggregator_request(endpoint, body_params)
    
    response = post(endpoint, body: body_params)
    
    log_people_aggregator_response(response)

    case response.code
    when 404 then
      Rails.logger.error("Could not find account with #{people_aggregator_id} on #{Civiccommons::PeopleAggregator.URL}")
      return false
    when 412
      handle_412(response)
    else
      return true
    end
    
  end

  private
  
  # Raise an argument error containing the missing key
  def self.handle_412(response)
    missing_key = response.parsed_response['msg'][/key (.*) is required/, 1]
    raise ArgumentError, 'The key "%s" is required.' % missing_key
  end

end
