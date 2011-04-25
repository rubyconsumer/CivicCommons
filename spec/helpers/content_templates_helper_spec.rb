require 'spec_helper'

describe ContentTemplatesHelper do

  context "parse_content_template" do

    let(:template) do
      Factory.create(:content_template)
    end

    it "returns the parsed template when found" do
      parse_content_template(template.id).should == template.template
      parse_content_template(template.cached_slug).should == template.template
    end

    it "returns blank when template not found" do
      parse_content_template('does not exist').should be_blank
    end

  end

end
