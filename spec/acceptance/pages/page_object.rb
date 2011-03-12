class PageObject

  attr_reader :page

  def initialize(page)
    @page = page 
  end

  def body
    @page.body
  end

  def status_code
    @page.status_code
  end

  def visit(url)
    @page.visit(url)
  end

  def is_json?
    # lambda { @data = JSON.parse(@page.body.strip) }.should_not raise_exception
    parse_json_body.nil?
  end

  def parse_json_body
    begin
      JSON.parse(@page.body.strip)
    rescue
      nil
    end
  end

end
