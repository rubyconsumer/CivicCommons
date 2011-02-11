class FilterConstraint
  def matches?(request)
    # Ideally, we could put
    #   :constraints => {:filter => ['active', 'popular']}
    # in our routes.rb, but constraints does not work with arrays
    ['active', 'popular'].include?(request.path.split('/').last)
  end
end
