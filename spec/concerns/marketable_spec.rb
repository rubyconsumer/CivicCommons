require 'spec_helper'

# Testing Class that implements methods required for Marketable
class MarketableTest < Person
  include Marketable

  def is_marketable?
    true
  end

  def subscribe_to_marketing_email
    true
  end
end


describe Marketable do
  before :each do
    attrs = Factory.attributes_for(:normal_person)
    @marketable = MarketableTest.new(attrs)
  end

  it "should be subscribable to email marketing" do
    @marketable.is_marketable?.should be_true
  end

  it "should subscribe to email list" do
    @marketable.subscribe_to_marketing_email.should be_true
    #@marketable.skip_shadow_account = true
    #@marketable.subscribe!.should be_true
  end
end
