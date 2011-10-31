class PageObject
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  attr_reader :page

  def initialize(page)
    @page = page 
  end

  def body
    @page.body
  end

  def path
    raise 'Path needs to be overriden in subclass'
  end

  def status_code
    @page.status_code
  end

  def visit(url = nil)
    @page.visit(url || path)
  end

  def visited?
    @page.current_path.should == path
  end

  def is_json?
    # lambda { @data = JSON.parse(@page.body.strip) }.should_not raise_exception
    parse_json_body.nil?
  end

  # uses the @page's methods if it doesn't exist here
  def method_missing(method, *args)
    args.empty? ? @page.send(method) : @page.send(method, *args)
  end

  def parse_json_body
    JSON.parse(@page.body.strip)
  rescue
    nil
  end

end
