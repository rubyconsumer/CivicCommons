class OrganizationDetail < ActiveRecord::Base
  def has_address?
        !street.empty? or !city.empty? or !region.empty? or !postal_code.empty?
  end
end
