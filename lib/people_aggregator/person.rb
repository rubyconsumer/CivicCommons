class PeopleAggregator::Person
  include PeopleAggregator::Connector
  include PeopleAggregator::ApiObject


  attr_allowable :login, :email, :id, :url,
                 :name, :profile, :firstName,
                 :lastName, :login, :password,
                 :profilePictureURL, :profileAvatarURL, :profileAvatarSmallURL,
                 :profilePictureWidth, :profilePictureHeight, 
                 :profileAvatarWidth, :profileAvatarHeight,
                 :profileAvatarSmallWidth, :profileAvatarSmallHeight

  def save
    @attrs.merge!(adminPassword: Civiccommons::PeopleAggregator.admin_password,
                  profilePictureWidth: 100,    profilePictureHeight: 100, 
                  profileAvatarWidth: 70,      profileAvatarHeight: 70,
                  profileAvatarSmallWidth: 40, profileAvatarSmallHeight: 40)

    self.class.log_people_aggregator_request('/peopleaggregator/newUser', body: @attrs)

    r = self.class.post('/peopleaggregator/newUser', body: @attrs)

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


  def destroy
    @attrs.merge!(adminPassword: "admin")
    r = self.class.post('/peopleaggregator/deleteUser', body: { adminPassword: @attrs[:adminPassword],
                                               login: self.login})

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
    self.new(attrs).tap { |p| p.save }
  end

  def self.find_by_email(email)
    r = get('/peopleaggregator/getUserProfile?login=%s' % email)

    log_people_aggregator_response r

    case r.code
    when 404
      return nil
    end

    attrs = r.parsed_response

    return nil unless r.parsed_response

    cleanup_attrs!(attrs)

    self.new(attrs)
  end


  private

  def self.cleanup_attrs!(attrs)
    attrs.delete("success")
    attrs.delete("name")
  end
end
