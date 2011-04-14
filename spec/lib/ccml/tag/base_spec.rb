require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class TestBaseTag < CCML::Tag::SingleTag
  def index
    return "Hello World!"
  end
end

describe CCML::Tag::Base do

  before(:all) do

    @http_url = 'http://www.theciviccommons.com'

    @https_url = 'https://www.theciviccommons.com'

    @url_no_path_no_qs = 'http://www.theciviccommons.com'

    @url_no_path_unformatted_qs = 'http://www.theciviccommons.com/?unformatted_query_string'

    @url_no_path_formatted_qs_one_field = 'http://www.theciviccommons.com?field=value'

    @url_no_path_formatted_qs_many_fields = 'http://www.theciviccommons.com?field1=value1&field2=value2&field3=value3'

    @url_with_path_one_segment_no_qs = 'http://www.theciviccommons.com/segment1'

    @url_with_path_one_segment_unformatted_qs = 'http://www.theciviccommons.com/segment1?unformatted_query_string'

    @url_with_path_one_segment_qs_one_field = 'http://www.theciviccommons.com/segment1?field=value'

    @url_with_path_one_segment_qs_many_fields = 'http://www.theciviccommons.com/segment1?field1=value1&field2=value2&field3=value3'

    @url_with_path_multiple_segments_no_qs = 'http://www.theciviccommons.com/segment1/segment2/segment3/'

    @url_with_path_multiple_segments_unformatted_qs = 'http://www.theciviccommons.com/segment1/segment2/segment3/?unformatted_query_string'

    @url_with_path_multiple_segments_qs_one_field = 'http://www.theciviccommons.com/segment1/segment2/segment3/?field=value'

    @url_with_path_multiple_segments_qs_many_fields = 'http://www.theciviccommons.com/segment1/segment2/segment3/?field1=value1&field2=value2&field3=value3'

  end

  context "url parsing" do

    context "no url" do

      before(:all) do
        @tag = TestBaseTag.new
      end

      it "should set the url to blank" do
        @tag.url.should be_blank
      end

      it "should set all protocol accessors to false" do
        @tag.http?.should be_false
        @tag.https?.should be_false
      end

      it "should set the host to blank" do
        @tag.host.should be_blank
      end

      it "should set the path to blank" do
        @tag.path.should be_blank
      end

      it "should set the query string to blank" do
        @tag.query_string.should be_blank
      end

      it "should return an empty array for the segment collection" do
        @tag.segments.should be_kind_of Array
        @tag.segments.should be_empty
      end

      it "should return an empty hash for the query field collection" do
        @tag.fields.should be_kind_of Hash
        @tag.fields.should be_empty
      end

    end

    context "protocol" do

      it "should recognize an http url" do
        tag = TestBaseTag.new({}, @http_url)
        tag.http?.should be_true
        tag.https?.should be_false
      end

      it "should recognize an https url" do
        tag = TestBaseTag.new({}, @https_url)
        tag.http?.should be_false
        tag.https?.should be_true
      end

    end

    context "host" do

      it "should correctly extract the host" do
        TestBaseTag.new({}, @http_url).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @https_url).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_no_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_unformatted_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).host.should == 'www.theciviccommons.com'
      end

    end

    context "resource" do

      it "should correctly extract the resource" do
        TestBaseTag.new({}, @http_url).resource.should be_blank
        TestBaseTag.new({}, @https_url).resource.should be_blank
        TestBaseTag.new({}, @url_no_path_no_qs).resource.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).resource.should == '/?unformatted_query_string'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).resource.should == '?field=value'
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).resource.should == '?field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).resource.should == '/segment1'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).resource.should == '/segment1?unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).resource.should == '/segment1?field=value'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).resource.should == '/segment1?field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).resource.should == '/segment1/segment2/segment3/'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).resource.should == '/segment1/segment2/segment3/?unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).resource.should == '/segment1/segment2/segment3/?field=value'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).resource.should == '/segment1/segment2/segment3/?field1=value1&field2=value2&field3=value3'
      end

    end

    context "path" do

      it "should correctly extract the path" do
        TestBaseTag.new({}, @http_url).path.should be_blank
        TestBaseTag.new({}, @https_url).path.should be_blank
        TestBaseTag.new({}, @url_no_path_no_qs).path.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).path.should be_blank
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).path.should be_blank
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).path.should be_blank
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).path.should == '/segment1'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).path.should == '/segment1'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).path.should == '/segment1'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).path.should == '/segment1'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).path.should == '/segment1/segment2/segment3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).path.should == '/segment1/segment2/segment3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).path.should == '/segment1/segment2/segment3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).path.should == '/segment1/segment2/segment3'
      end

    end

    context "query string" do

      it "should correctly extract the query string" do
        TestBaseTag.new({}, @http_url).query_string.should be_blank
        TestBaseTag.new({}, @https_url).query_string.should be_blank
        TestBaseTag.new({}, @url_no_path_no_qs).query_string.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).query_string.should == 'unformatted_query_string'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).query_string.should == 'field=value'
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).query_string.should == 'field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).query_string.should be_blank
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).query_string.should == 'unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).query_string.should == 'field=value'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).query_string.should == 'field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).query_string.should be_blank
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).query_string.should == 'unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).query_string.should == 'field=value'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).query_string.should == 'field1=value1&field2=value2&field3=value3'
      end

    end

    context "segments" do

      it "should extract the correct segment values" do
        TestBaseTag.new({}, @http_url).segments.should be_empty
        TestBaseTag.new({}, @https_url).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_no_qs).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_unformatted_qs).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_formatted_qs_one_field).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_formatted_qs_many_fields).segments.should be_empty
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).segments.should == [ 'segment1' ]
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).segments.should == [ 'segment1' ]
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).segments.should == [ 'segment1' ]
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).segments.should == [ 'segment1' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).segments.should == [ 'segment1', 'segment2', 'segment3' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).segments.should == [ 'segment1', 'segment2', 'segment3' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).segments.should == [ 'segment1', 'segment2', 'segment3' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).segments.should == [ 'segment1', 'segment2', 'segment3' ]
      end
    end

    context "fields" do

      it "should extract the correct key/value pairs" do
        TestBaseTag.new({}, @http_url).fields.should be_empty
        TestBaseTag.new({}, @https_url).fields.should be_empty
        TestBaseTag.new({}, @url_no_path_no_qs).fields.should be_empty
        TestBaseTag.new({}, @url_no_path_unformatted_qs).fields.should be_empty
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).fields.should == { :field => 'value' }
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).fields.should == { :field1 => 'value1', :field2 => 'value2', :field3 => 'value3' }
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).fields.should == { :field => 'value' }
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).fields.should == { :field1 => 'value1', :field2 => 'value2', :field3 => 'value3' }
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).fields.should == { :field => 'value' }
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).fields.should == { :field1 => 'value1', :field2 => 'value2', :field3 => 'value3' }
      end

    end

  end

end
