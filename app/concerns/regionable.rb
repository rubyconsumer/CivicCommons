module Regionable
  
  def region 
    region = Region.find_by_zip_code(self.zip_code)
    region ||= Region.default
  end

#  TODO: i would've liked for this to work, but it wasn't always loaded at the right time so i moved it to region.rb
#  def self.included(base)
#    # if regionable is included in Issue, then it will create a method to return all issues for a region
#    new_method = base.to_s.downcase.pluralize
#    Region.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
#      def #{new_method}
#        where_clause = "zip_code NOT IN (SELECT DISTINCT zip_code FROM zip_codes)"
#        where_clause = "zip_code IN (" + zip_code_string.gsub(/\n/,",") + ")" unless self.name == Region.default_name
#        return #{base.to_s}.where(where_clause)
#      end
#    ruby_eval
#  end
end
