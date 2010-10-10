class Region < ActiveRecord::Base

  before_save :create_zip_codes
  class << self
    DEFAULT_NAME = "National"
    def default 
      new(:name=>DEFAULT_NAME)
    end
  end

  has_many :zip_codes
  accepts_nested_attributes_for :zip_codes

  def zip_code_string
    self.zip_codes.collect{|c| c.zip_code}.join("\n")
  end
  
  def zip_code_string=(val)
    @zip_code_string = val  
    create_zip_codes 
  end

  def create_zip_codes
    self.zip_codes.clear
    @zip_code_string.split("\n").each do |c|
      self.zip_codes << ZipCode.find_or_create_by_zip_code(c.strip)
      puts "added #{c}"
    end
    puts "done adding zipcodes #{self.zip_code_string}"
  end
end
