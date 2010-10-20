require 'spec_helper'

describe AttachedFile do
  
  it "should return false when content type is not an image" do
    attached_file = AttachedFile.
      new(:attachment_content_type => "application/vnd.ms-excel")

    attached_file.is_image?.should_not be_nil
    attached_file.is_image? == false
  end
  
end
