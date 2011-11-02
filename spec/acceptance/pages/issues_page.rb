class IssuesPage < PageObject
  
  def path
    '/issues'
  end

  def initialize(page)
    super(page)
    @url_base = "/issues/"
  end

end
