class PeopleAggregator::Person
  include PeopleAggregator::Connector

  base_uri "http://civiccommons.digitalcitymechanics.com/api/json.php/peopleaggregator"

  def initialize(attrs)
    @attrs =  attrs.each do |k,v|
                self.class.send(:attr_reader, k.to_sym)
                self.instance_variable_set("@#{k}", v)
              end
  end


  def save
    @attrs.merge!(adminPassword: "admin")
    r = self.class.post('/newUser', body: @attrs)

    self.class.log_people_aggregator_response r

    case r.code
    when 412
      missing_key = r.parsed_response['msg'][/key (.*) is required/, 1]
      raise ArgumentError, 'The key "%s" is required.' % missing_key
    when 409
      login_name = r.parsed_response['msg'][/Login name (.*) is already taken/, 1]
      raise StandardError, 'The user with login "%s" already exists.' % login_name
    end
  end


  def destroy(password)
    @attrs.merge!(adminPassword: "admin")
    r = self.class.post('/deleteUser', body: { adminPassword: @attrs[:adminPassword],
                                               login: self.login,
                                               password: password})

    self.class.log_people_aggregator_response r

    case r.code
    when 412
      missing_key = r.parsed_response['msg'][/key (.*) is required/, 1]
      raise ArgumentError, 'The key "%s" is required.' % missing_key
    when 404
      login_name = r.parsed_response['msg'][/Login name (.*) is already taken/, 1]
      raise StandardError, 'The user with login "%s" doesn\'t exist.' % login_name
    end

    self
  end


  def self.create(attrs)
    self.new(attrs).save
  end

  def self.find_by_email(email)
    r = get('/getUserProfile?login=%s' % email)

    log_people_aggregator_response r

    case r.code
    when 404
      return nil
    end

    attrs = r.parsed_response
    self.new(attrs)
  end


end
