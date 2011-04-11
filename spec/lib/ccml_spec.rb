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
end

describe "module and class hierarchy" do

  context "tag classes" do

    it "should instance a single tag subclass" do
      tag = CCML::Tag::TestSingleTag.new
      tag.should be_a_kind_of CCML::Tag::SingleTag
    end

    it "should raise NotImplementedError when creating a TagPair subclass" do
      lambda { tag = CCML::Tag::TestPairTag.new }.should raise_error CCML::Error::NotImplementedError
    end

  end

  context "exception classes" do

    it "should recognize MalformedTagError" do
      error = CCML::Error::MalformedTagError.new
      error.should be_a_kind_of CCML::Error::Base
      error.should be_a_kind_of CCML::Error::MalformedTagError
    end

    it "should recognize NotImplementedError" do
      error = CCML::Error::NotImplementedError.new
      error.should be_a_kind_of CCML::Error::Base
      error.should be_a_kind_of CCML::Error::NotImplementedError
    end

    it "should recognize TagBaseClassInTemplateError" do
      error = CCML::Error::TagBaseClassInTemplateError.new
      error.should be_a_kind_of CCML::Error::Base
      error.should be_a_kind_of CCML::Error::TagBaseClassInTemplateError
    end

    it "should recognize TagClassNotFoundError" do
      error = CCML::Error::TagClassNotFoundError.new
      error.should be_a_kind_of CCML::Error::Base
      error.should be_a_kind_of CCML::Error::TagClassNotFoundError
    end

    it "should recognize TagMethodNotFoundError" do
      error = CCML::Error::TagMethodNotFoundError.new
      error.should be_a_kind_of CCML::Error::Base
      error.should be_a_kind_of CCML::Error::TagMethodNotFoundError
    end

    it "should recognize TemplateError" do
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

      @single_tag_no_method_with_opts = "{ccml:test_single text='Hello Again!' opt1='nothing' opt2='important'}"

      @single_tag_with_method_with_opts = "{ccml:test_single:echo text='Hello Again!' opt1='nothing' opt2='important'}"

      # tag pair examples

      @tag_pair_no_method_no_opts = "{ccml:test_pair}
        {property}
      {/ccml:test_pair}"

      @tag_pair_with_method_no_opts = "{ccml:test_pair:echo}
        {property}
      {/ccml:test_pair}"

      @tag_pair_no_method_with_opts = "{ccml:test_pair text='Hello Again!' opt1='nothing' opt2='important'}
        {property}
      {/ccml:test_pair}"

      @tag_pair_with_method_with_opts = "{ccml:test_pair:echo text='Hello Again!' opt1='nothing' opt2='important'}
        {property}
      {/ccml:test_pair}"

      # incorrect syntax examples

      @single_tag_missing_class = "{ccml:bogus_class}"

      @single_tag_missing_method = "{ccml:test_single:bogus_method}"

      @single_tag_bad_syntax = "{ccml garbage}"

      @tag_pair_bad_syntax = "{ccml:stuff garbage}some stuff in the middle{/ccml:stuff}"

    end

    context "single tag" do

      it "should parse a single tag with no method and no options" do
        CCML.parse(@single_tag_no_method_no_opts).should == "Hello World!"
      end

      it "should parse a single tag with method and no options" do
        CCML.parse(@single_tag_with_method_no_opts).should == "Hello World!"
      end

      it "should parse a single tag with no method and with options" do
        CCML.parse(@single_tag_no_method_with_opts).should == "Hello Again!"
      end

      it "should parse a single tag with method and with options" do
        CCML.parse(@single_tag_with_method_with_opts).should == "Hello Again!"
      end

      it "should parse multiple single tags" do
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

    end

    context "tag pair" do

      it "should parse a tag pair with no method and no options" do
        lambda { CCML.parse(@tag_pair_no_method_no_opts) }.should raise_error CCML::Error::NotImplementedError
      end

      it "should parse a tag pair with method and no options" do
        lambda { CCML.parse(@tag_pair_with_method_no_opts) }.should raise_error CCML::Error::NotImplementedError
      end

      it "should parse a tag pair with no method and with options" do
        lambda { CCML.parse(@tag_pair_no_method_with_opts) }.should raise_error CCML::Error::NotImplementedError
      end

      it "should parse a tag pair with method and with options" do
        lambda { CCML.parse(@tag_pair_with_method_with_opts) }.should raise_error CCML::Error::NotImplementedError
      end

    end

    context "incorrect tag syntax" do

      it "should raise TagClassNotFoundError when tag class does not exist" do
        lambda { CCML.parse(@single_tag_missing_class) }.should raise_error CCML::Error::TagClassNotFoundError
      end

      it "should raise TagMethodNotFoundError when tag method does not exist" do
        lambda { CCML.parse(@single_tag_missing_method) }.should raise_error CCML::Error::TagMethodNotFoundError
      end

      it "should raise TemplateError when ccml data is not a string" do
        lambda { CCML.parse(1234567890) }.should raise_error CCML::Error::TemplateError
      end

      it "should raise TemplateError for a malformed single tag" do
        lambda { CCML.parse(@single_tag_bad_syntax) }.should raise_error CCML::Error::TemplateError
      end

      it "should raise TemplateError for a malformed tag pair" do
        lambda { CCML.parse(@tag_pair_bad_syntax) }.should raise_error CCML::Error::TemplateError
      end

    end

  end

end
