module Regionable
  
  def region 
    Region.find_by_zip_code(self.zip_code)
  end

end
