require 'spec_helper'

describe ReflectionComment do
  describe "associations" do
    it { should belong_to :reflection}
    it { should belong_to :person}
  end
  describe "validations" do
    it { should validate_presence_of :body}
  end
end
