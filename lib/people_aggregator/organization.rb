class PeopleAggregator::Organization
  include PeopleAggregator::Connector
  include PeopleAggregator::ApiObject


  attr_allowable :login, :email, :id, :url,
                 :name, :profile, :firstName,
                 :lastName, :login, :password,
                 :profilePictureURL, :groupName,
                 :image


  def save

    @attrs.merge!(adminPassword: "admin",
                  groupType: "store",
                  category: "cat:1",
                  tags: "tmp",
                  description: "tmp",
                  accessType: "public",
                  registrationType: "moderated",
                  image: "",
                  moderationType: "direct")

    self.class.log_people_aggregator_request('/civiccommons/newOrg', body: @attrs)

    r = self.class.post('/civiccommons/newOrg', body: @attrs)

    self.class.log_people_aggregator_response r

    case r.code
    when 412
      missing_key = r.parsed_response['msg'][/key (.*) is required/, 1]
      raise ArgumentError, 'The key "%s" is required.' % missing_key
    when 409
      login_name = r.parsed_response['msg'][/Login name (.*) is already taken/, 1]
      raise StandardError, 'The user with login "%s" already exists.' % login_name
    end

    self.id = r.parsed_response["id"]

    r.code == 200
  end


  def self.find_by_admin_email(email)
    r = get('/get...?email=%s' % email)

    log_people_aggregator_response r

    case r.code
    when 404
      return nil
    end

    attrs = r.parsed_response

    cleanup_attrs!(attrs)

    self.new(attrs)

  end


  def self.create(attrs)
    self.new(attrs).tap { |p| p.save }
  end


end
