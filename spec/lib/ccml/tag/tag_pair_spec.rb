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

      before(:all) do
        @tag = TestPairTag.new(@ccml_options)
        @tag.tag_body = @ccml_tag_body
      end

      it "should properly process a simple hash" do
        @tag.single_hash.should == @ccml_processed_once
      end

      it "should properly process an array of simple hashes" do
        @tag.array_of_hashes.should == @ccml_processed_thrice
      end

      it "should properly process an object" do
        @tag.obj = @person
        @tag.single_object.should == @ccml_processed_once
      end

      it "should properly process an array of objects" do
        @tag.obj = @person
        @tag.array_of_objects.should == @ccml_processed_thrice
      end

    end

    context "with conditionals" do

      before(:all) do

        @tag = TestPairTag.new({})

      @full_conditional =
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{if:elsif first_name == 'Paul'}
<h2>Ebony and ivory.</h2>
{if:elseif first_name == 'George'}
<h3>{first_name}, you are the quiet one.</h3>
{if:else}
<h4>You must be {first_name}!</h4>
{/if}"

      @if_conditional
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{/if}"

      @multiple_conditionals =
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{if:elsif first_name == 'Paul'}
<h2>Ebony and ivory.</h2>
{if:elseif first_name == 'George'}
<h3>{first_name}, you are the quiet one.</h3>
{if:else}
<h4>You must be {first_name}!</h4>
{/if}

{if first_name == 'John'}
<h1>I am the walrus.</h1>
{/if}"
      end

      it "should handle an if conditional" do
        @tag.obj = Factory.build(:registered_user, :first_name => 'John')
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h1>I am the walrus.</h1>\n"
      end

      it "should handle an elsif conditional (Ruby-style)" do
        @tag.obj = { 'first_name' => 'Paul' }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h2>Ebony and ivory.</h2>\n"
      end

      it "should handle an elseif conditional (ExpressionEngine-style)" do
        @tag.obj = { :first_name => 'George' }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h3>George, you are the quiet one.</h3>\n"
      end

      it "should handle an else conditional" do
        @tag.obj = { :first_name => 'Ringo' }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h4>You must be Ringo!</h4>\n"
      end

      it "should handle a conditional expression against a non-existent property" do
        @tag.obj = { }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h4>You must be !</h4>\n"
      end

      it "should handle a conditional with no true branches" do
        @tag.obj = { }
        @tag.tag_body = @if_conditional
        @tag.single_object.should be_blank
      end

      it "should handle an multiple conditionals" do
        @tag.obj = Factory.build(:registered_user, :first_name => 'John')
        @tag.tag_body = @multiple_conditionals
        @tag.single_object.should == "\n<h1>I am the walrus.</h1>\n\n\n\n<h1>I am the walrus.</h1>\n"
      end

    end

  end

end
