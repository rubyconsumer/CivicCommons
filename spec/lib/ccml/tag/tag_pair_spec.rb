require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class TestPairTag < CCML::Tag::TagPair
  attr_accessor :obj
  def single_hash
    return process_tag_body(@opts)
  end
  def array_of_hashes
    opts = [ @opts, @opts, @opts ]
    return process_tag_body(opts)
  end
  def single_object
    return process_tag_body(@obj)
  end
  def array_of_objects
    objs = [ @obj, @obj, @obj ]
    return process_tag_body(objs)
  end
end

describe CCML::Tag::TagPair do

  context "process_tag_body" do

    before(:all) do

      @person = Factory.build(:registered_user, :id => 1, :first_name => 'John', :last_name => 'Doe')

      @ccml_options = {
        :id => @person.id.to_s,
        :first_name => @person.first_name,
        :last_name => @person.last_name,
      }

      @ccml_template = "{ccml:test_pair id='1' first_name='John' last_name=\"Doe\"}<h1>ID {id}</h1><p>Hello, {first_name} {last_name}!</p>{/ccml:test_pair}"

      @ccml_tag_body = "<h1>ID {id}</h1><p>Hello, {first_name} {last_name}!</p>"

      @ccml_processed_once = "<h1>ID 1</h1><p>Hello, John Doe!</p>"

      @ccml_processed_twice = "<h1>ID 1</h1><p>Hello, John Doe!</p><h1>ID 1</h1><p>Hello, John Doe!</p>"

      @ccml_processed_thrice = "<h1>ID 1</h1><p>Hello, John Doe!</p><h1>ID 1</h1><p>Hello, John Doe!</p><h1>ID 1</h1><p>Hello, John Doe!</p>"

    end

    context "without conditionals" do

      it "should properly process a simple hash" do

        tag = TestPairTag.new(@ccml_options)
        tag.tag_body = @ccml_tag_body
        tag.single_hash.should == @ccml_processed_once

      end

      it "should properly process an array of simple hashes" do

        tag = TestPairTag.new(@ccml_options)
        tag.tag_body = @ccml_tag_body
        tag.array_of_hashes.should == @ccml_processed_thrice

      end

      it "should properly process an object" do

        tag = TestPairTag.new(@ccml_options)
        tag.tag_body = @ccml_tag_body
        tag.obj = @person
        tag.single_object.should == @ccml_processed_once

      end

      it "should properly process an array of objects" do

        tag = TestPairTag.new(@ccml_options)
        tag.tag_body = @ccml_tag_body
        tag.obj = @person
        tag.array_of_objects.should == @ccml_processed_thrice

      end

    end

    context "with conditionals" do

      before(:all) do

        @conditional = 
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{if:elsif first_name == 'Paul'}
<h1>Ebony and ivory.</h1>
{if:elsif first_name == 'George'}
<h1>You are the quiet one.</h1>
{if:else}
<h1>You must be Ringo!</h1>
{/if}"

      end

      it "should handle an if conditional" do

        @person.first_name = 'John'
        tag = TestPairTag.new({})
        tag.tag_body = @conditional
        tag.obj = @person
        #tag.single_object.should == @ccml_processed_thrice
        tag.single_object

      end

      it "should handle an elsif conditional" do
        pending
      end

      it "should handle an else conditional" do
        pending
      end

    end

  end

end
