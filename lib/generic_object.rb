require 'ostruct'

class GenericObject < OpenStruct

  def name
    if self.respond_to?('first_name') and self.respond_to?('last_name')
      return ("%s %s" % [self.first_name, self.last_name]).strip
    end
    return ''
  end

end
