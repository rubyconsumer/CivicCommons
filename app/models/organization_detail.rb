class OrganizationDetail < ActiveRecord::Base
  def has_address?
        street.present? or city.present? or region.present? or postal_code.present?
  end
end
