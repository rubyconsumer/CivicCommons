class FilterConstraint
  def self.matches?(request)
    # Ideally, we could put
    #   :constraints => {:filter => ['active', 'popular']}
    # in our routes.rb, but constraints does not work with arrays
    resource, filter = request.path.split('/').last(2)
    resource = resource.singularize.camelize.constantize
    available_filters = resource.available_filter_names || []
    available_filters.include?(filter)
  end
end
