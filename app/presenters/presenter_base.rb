class PresenterBase < Delegator
  include Rails.application.routes.url_helpers

  attr_reader :request

  def initialize(object, request=nil)
    @object = object
    @request = request
  end

  def __getobj__; @object end

  def __setobj__(object); @object = object end

end
