require File.expand_path(File.dirname(__FILE__) + '/page_object')

class ApiPage < PageObject

  def initialize(page)
    super(page)
    @url_base = '/api/'
  end

  def visit_subscriptions(person = nil)
    if person.nil?
      visit @url_base + 'subscriptions'
    else
      visit "#{@url_base}#{person.id}/subscriptions"
    end
  end

end
