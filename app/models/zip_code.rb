class ZipCode < ActiveRecord::Base
  
  belongs_to :region
  
  def to_s
    self.zip_code
  end
end
