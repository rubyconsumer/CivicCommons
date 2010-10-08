class PeopleAggregator::Login
  include PeopleAggregator::Connector
  include PeopleAggregator::ApiObject
  
  base_uri "#{Civiccommons::PeopleAggregator.URL}/api/json.php/peopleaggregator"
  
  attr_allowable :login, :password, :authToken, :tokenLifetime
  
  def self.login(login, password)
    r = post('/login', body: { adminPassword: 'admin',
                                          login: login,
                                          password: password})

    log_people_aggregator_response r
    
    case r.code
    when 404
      return nil
    end
    
    attrs = r.parsed_response
    
    cleanup_attrs!(attrs)
    
    self.new(attrs)
  end
  
  
  private
    def self.cleanup_attrs!(attrs)
      attrs.delete("success")
    end
end
