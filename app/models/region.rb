class Region < ActiveRecord::Base

  before_save :create_zip_codes
  class << self
    def default_name
      "National"
    end

    def default 
      rv = new(:name=>self.default_name)
      rv.id = 0
      rv
    end

  end

  [Issue, Conversation, Person].each do |klass|
    new_method = klass.name.to_s.downcase.pluralize
    paginate = ".paginate(:page=>page, :per_page=>6)" if klass == Conversation

    Region.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
      def #{new_method}(page = 1)
        where_clause = "zip_code NOT IN (SELECT DISTINCT zip_code FROM zip_codes)"
        unless self.name == Region.default_name 
          where_clause = "zip_code IN (" + zip_code_string.gsub(/\n/,",") + ")" 
          where_clause = "zip_code = 'NOT A ZIPCODE'" unless zip_code_string.length > 0
        end
        return #{klass.name.to_s}.where(where_clause)#{paginate}
      end
    ruby_eval
  end


  has_many :zip_codes
  accepts_nested_attributes_for :zip_codes

  has_attached_file :image, 
    :styles => {:normal => "300x200>"},
      :storage => :s3,
      :s3_credentials => S3Config.credential_file,
      :path => ":attachment/region/:id/:style/:filename"

  def default?
    self.name == Region.default_name
  end

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
    end
  end
end
