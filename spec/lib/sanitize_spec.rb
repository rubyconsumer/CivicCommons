require 'spec_helper'
require 'sanitize'

describe Sanitize do
  context "will remove HTML elements" do
    before(:all) do
      @html = '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg">'
      @text = 'This is a sentance\' without HTML tags in it which is > not.'
    end

    it "when tags exist" do
      Sanitize.clean(@html).should == 'foo'
    end

    it "when tags do not exist" do
      Sanitize.clean(@text).should == CGI.escapeHTML(@text)
    end

  end
end