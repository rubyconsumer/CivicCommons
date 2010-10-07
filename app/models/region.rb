class Region < ActiveRecord::Base
  has_many :zip_codes
  has_many :counties
  accepts_nested_attributes_for :zip_codes

  def state
    if self.counties.length > 0 && !self.counties.first.nil? 
      @state ||= self.counties.first.state 
    else
      @state ||= ""
    end
    @state
  end

  def state=(val)
    @state=val
  end

  def county_string
    @county_string ||= self.counties.collect{|c| c.name}.join("\n")
  end
  
  def county_string=(val)
    @county_string = val  
    create_counties 
  end

  def create_counties
    self.counties.clear
    self.county_string.split("\n").each do |c|
      self.counties << County.find_or_create_by_name_and_state(c.strip, self.state)
    end
  end
end
