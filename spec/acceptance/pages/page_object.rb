class PageObject

  def initialize(page)
    @page = page 
  end

  def body
    @page.body
  end

  def visit(url)
    @page.visit(url)
  end

end
