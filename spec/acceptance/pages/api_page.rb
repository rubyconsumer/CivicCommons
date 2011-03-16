require File.expand_path(File.dirname(__FILE__) + '/page_object')

class ApiPage < PageObject

  def initialize(page)
    super(page)
    @url_base = '/api/'
  end

  def visit_subscriptions(person, type = nil)
    if person.respond_to?(:id)
      id = person.id
    else
      id = person.to_i
    end

    if type.nil?
      visit "#{@url_base}#{id}/subscriptions"
    else
      visit "#{@url_base}#{id}/subscriptions?type=#{type.singularize}"
    end
  end

end
