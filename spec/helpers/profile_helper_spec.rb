$LOAD_PATH << '.'
require 'app/helpers/profile_helper'
class TestProfileHelper
  include ProfileHelper
  def link_to body, url
    "<a href=\"#{url}\">#{body}</a>"
  end
end
describe ProfileHelper do
  let(:helper) { TestProfileHelper.new }
  describe "#contact_info" do
    context "when it has empty stuff" do
      subject { helper.contact_info_for(stub(profile_data: { address: "" })) }
      it { should == "" }
    end
    context "with an address" do
      subject { helper.contact_info_for(stub(profile_data: { address: '1234, west south street' })) }
      it { should include "<li>1234, west south street</li>" }
    end
    context "with a twitter profile" do
      subject { helper.contact_info_for(stub(profile_data: { twitter: "1234" })) }
      it { should include "<li class=\"twitter-profile\"><a href=\"http://twitter.com/#!/1234\">@1234</a></li>" }
    end
    context "with a website" do
      subject { helper.contact_info_for(stub(profile_data: { website: "http://www.google.com/" })) }
      it { should include "<li class=\"website-profile\"><a href=\"http://www.google.com/\">Website</a></li>" }
    end
    context "with a phone number" do
      subject { helper.contact_info_for(stub(profile_data: { phone: "1-234-567-8901" })) }
      it { should include "<li>P: 1-234-567-8901</li>" }
    end
    context "with a facebook profile" do
      subject { helper.contact_info_for(stub(profile_data: { facebook: "http://facebook.com/" })) }
      it { should include "<li class=\"facebook-profile\"><a href=\"http://facebook.com/\">Facebook</a></li>" }
    end
  end
end
