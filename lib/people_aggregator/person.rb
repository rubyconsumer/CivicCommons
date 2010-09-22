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
  end


  def self.create(attrs)
    self.new(attrs).save
  end

  def self.find_by_email(email)
    attrs = get('/getUserProfile?login=%s' % email).parsed_response
    self.new(attrs)
  end


end
