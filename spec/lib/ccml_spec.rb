require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

class CCML::Tag::TestSingleTag < CCML::Tag::SingleTag
  def index
    return echo
  end
  def echo
    if @opts.empty? or not @opts.has_key?(:text)
      return "Hello World!"
    else
      return @opts[:text]
    end
  end
end

class CCML::Tag::TestPairTag < CCML::Tag::TagPair
  def index
    return "Hello world!"
  end
  def echo
    return @opts.to_s
  end
end

describe CCML do

  describe "module and class hierarchy" do

    context "tag classes" do

      it "instances a single tag subclass" do
        tag = CCML::Tag::TestSingleTag.new(nil)
        tag.should be_a_kind_of CCML::Tag::SingleTag
      end

      it "instances a tag pair subclass" do
        tag = CCML::Tag::TestPairTag.new(nil)
        tag.should be_a_kind_of CCML::Tag::TagPair
      end

    end

    context "exception classes" do

      it "recognizes MalformedTagError" do
        error = CCML::Error::MalformedTagError.new
        error.should be_a_kind_of CCML::Error::Base
        error.should be_a_kind_of CCML::Error::MalformedTagError
      end

      it "recognizes NotImplementedError" do
        error = CCML::Error::NotImplementedError.new
        error.should be_a_kind_of CCML::Error::Base
        error.should be_a_kind_of CCML::Error::NotImplementedError
      end

      it "recognizes TagBaseClassInTemplateError" do
        error = CCML::Error::TagBaseClassInTemplateError.new
        error.should be_a_kind_of CCML::Error::Base
        error.should be_a_kind_of CCML::Error::TagBaseClassInTemplateError
      end

      it "recognizes TagClassNotFoundError" do
        error = CCML::Error::TagClassNotFoundError.new
        error.should be_a_kind_of CCML::Error::Base
        error.should be_a_kind_of CCML::Error::TagClassNotFoundError
      end

      it "recognizes TagMethodNotFoundError" do
        error = CCML::Error::TagMethodNotFoundError.new
        error.should be_a_kind_of CCML::Error::Base
        error.should be_a_kind_of CCML::Error::TagMethodNotFoundError
      end

      it "recognizes TemplateError" do
        error = CCML::Error::TemplateError.new
        error.should be_a_kind_of CCML::Error::Base
        error.should be_a_kind_of CCML::Error::TemplateError
      end

    end

    describe "CCML#parse" do

      before(:all) do

        # single tag examples

        @single_tag_no_method_no_opts = "{ccml:test_single}"

        @single_tag_with_method_no_opts = "{ccml:test_single:echo}"

        @single_tag_no_method_with_opts = "{ccml:test_single text=\"Hello Again!\" opt1='nothing' opt2=\"important\"}"

        @single_tag_with_method_with_opts = "{ccml:test_single:echo text='Hello Again!' opt1=\"nothing\" opt2='important'}"

        # tag pair examples

        @tag_pair_no_method_no_opts = "{ccml:test_pair}
          {property}
        {/ccml:test_pair}"

        @tag_pair_with_method_no_opts = "{ccml:test_pair:echo}
          {property}
        {/ccml:test_pair:echo}"

        @tag_pair_no_method_with_opts = "{ccml:test_pair text=\"Hello Again!\" opt1='nothing' opt2=\"important\"}
          {property}
        {/ccml:test_pair}"

        @tag_pair_with_method_with_opts = "{ccml:test_pair:echo text='Hello Again!' opt1=\"nothing\" opt2='important'}
          {property}
        {/ccml:test_pair:echo}"

        # multiple tags

        @multiple_tag_pairs = "{ccml:test_pair:echo text='Hello Again!' opt1=\"nothing\" opt2='important'}
          {property}
        {/ccml:test_pair:echo}
        {ccml:test_pair:echo}
          {property1}
          {property2}
          {property3}
          {property4}
        {/ccml:test_pair:echo}
        {ccml:test_pair}
          Lorem ipsum...
        {/ccml:test_pair}
        "

        @multiple_tags_both_types = "{ccml:test_pair:echo text='Hello Again!' opt1=\"nothing\" opt2='important'}
          {property}
        {/ccml:test_pair:echo}
        {ccml:test_single}
        {ccml:test_single:echo text='Hello Again!' opt1=\"nothing\" opt2='important'}
        {ccml:test_pair:echo}
          {property1}
          {property2}
          {property3}
          {property4}
        {/ccml:test_pair:echo}
        {ccml:test_pair}
          Lorem ipsum...
        {/ccml:test_pair}
        "

        # incorrect syntax examples

        @single_tag_missing_class = "{ccml:bogus_class}"

        @single_tag_missing_method = "{ccml:test_single:bogus_method}"

        @single_tag_incomplete = "{ccml:test_single"

        @tag_pair_incomplete_open = "{ccml:test_pair yada, yada, yada {/ccml:test_pair}"

        @tag_pair_incomplete_close = "{ccml:test_pair} yada, yada, yada {/ccml:test_pair"

        @tag_pair_mismatched_pair = "{ccml:test_pair}some stuff in the middle{/ccml:mismatch}"

        @tag_pair_mismatched_close_method = "{ccml:test_pair:echo}some stuff in the middle{/ccml:test_pair:mismatch}"

        @tag_pair_missing_close_method = "{ccml:test_pair:echo}some stuff in the middle{/ccml:test_pair}"

      end

      context "single tag" do

        it "parses a single tag with no method and no options" do
          CCML.parse(@single_tag_no_method_no_opts).should == "Hello World!"
        end

        it "parses a single tag with method and no options" do
          CCML.parse(@single_tag_with_method_no_opts).should == "Hello World!"
        end

        it "parses a single tag with no method and with options" do
          CCML.parse(@single_tag_no_method_with_opts).should == "Hello Again!"
        end

        it "parses a single tag with method and with options" do
          CCML.parse(@single_tag_with_method_with_opts).should == "Hello Again!"
        end

      end

      context "tag pair" do

        it "parses a tag pair with no method and no options" do
          CCML.parse(@tag_pair_no_method_no_opts).should == "Hello world!"
        end

        it "parses a tag pair with method and no options" do
          CCML.parse(@tag_pair_with_method_no_opts).should == '{}'
        end

        it "parses a tag pair with no method and with options" do
          CCML.parse(@tag_pair_no_method_no_opts).should == "Hello world!"
        end

        it "parses a tag pair with method and with options" do
          CCML.parse(@tag_pair_with_method_with_opts).should == '{:text=>"Hello Again!", :opt1=>"nothing", :opt2=>"important"}'
        end

      end

      context "multiple tags" do

        it "correctly parses multiple single tags" do
          ccml = "BEGIN > "
          ccml << @single_tag_no_method_no_opts
          ccml << " ... "
          ccml << @single_tag_with_method_no_opts
          ccml << " ... "
          ccml << @single_tag_no_method_with_opts
          ccml << " ... "
          ccml << @single_tag_with_method_with_opts
          ccml << " < END"
          CCML.parse(ccml).should == "BEGIN > Hello World! ... Hello World! ... Hello Again! ... Hello Again! < END"
        end

        it "correctly parses multiple tag pairs" do
          CCML.parse(@multiple_tag_pairs).should == "{:text=>\"Hello Again!\", :opt1=>\"nothing\", :opt2=>\"important\"}\n        {}\n        Hello world!\n        "
        end

        it "correctly parses multiple single tags and tag pairs" do
          CCML.parse(@multiple_tags_both_types).should == "{:text=>\"Hello Again!\", :opt1=>\"nothing\", :opt2=>\"important\"}\n        Hello World!\n        Hello Again!\n        {}\n        Hello world!\n        "
        end

      end

      context "incorrect tag syntax" do

        it "raises TemplateError when ccml data is not a string" do
          lambda { CCML.parse(1234567890) }.should raise_error CCML::Error::TemplateError
        end

        it "raises TagClassNotFoundError when tag class does not exist" do
          lambda { CCML.parse(@single_tag_missing_class) }.should raise_error CCML::Error::TagClassNotFoundError
        end

        it "raises TagMethodNotFoundError when tag method does not exist" do
          lambda { CCML.parse(@single_tag_missing_method) }.should raise_error CCML::Error::TagMethodNotFoundError
        end

        it "raises TemplateError for incomplete single tag" do
          lambda { CCML.parse(@single_tag_incomplete) }.should raise_error CCML::Error::TemplateError
        end

        it "raises TemplateError for incomplete tag pair open tag" do
          lambda { CCML.parse(@tag_pair_incomplete_open) }.should raise_error CCML::Error::TemplateError
        end

        it "raises TemplateError for incomplete tag pair close tag" do
          lambda { CCML.parse(@tag_pair_incomplete_close) }.should raise_error CCML::Error::TemplateError
        end

        it "raises TemplateError for a mismatched tag pair" do
          lambda { CCML.parse(@tag_pair_mismatched_pair) }.should raise_error CCML::Error::TemplateError
        end

        it "raises TemplateError for a mismatched close tag mathod" do
          lambda { CCML.parse(@tag_pair_mismatched_close_method) }.should raise_error CCML::Error::TemplateError
        end

        it "raises TemplateError for a missing close tag method" do
          lambda { CCML.parse(@tag_pair_missing_close_method) }.should raise_error CCML::Error::TemplateError
        end

      end

    end

  end

end
