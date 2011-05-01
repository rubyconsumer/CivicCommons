require 'spec_helper'

describe Rating do
  before(:each) do
    @current_person = Factory.create(:normal_person)
    @contribution = Factory.create(:comment)
    @descriptor = Factory.create(:rating_descriptor)
    @descriptor2 = Factory.create(:rating_descriptor, :title => "Motivating")
    @rg = Factory.create(:rating_group, :contribution => @contribution, :person => @current_person)
    @rating = Factory.create(:rating, :rating_group => @rg, :rating_descriptor => @descriptor)
    @rating2 = Factory.create(:rating, :rating_group => @rg, :rating_descriptor => @descriptor2)
    @rating1b = Factory.create(:rating, :rating_descriptor => @descriptor)
  end

  it "should have a descriptor" do
    @rating.rating_descriptor.title.should == "Inspiring"
  end

  it "should display the descriptor when using the title shortcut" do
    @rating.title.should == "Inspiring"
  end

end

