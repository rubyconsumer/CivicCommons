class AddSeedRatingDescriptors < ActiveRecord::Migration
  def self.up
    ["Persuasive", "Informative", "Inspiring"].each do |desc|
      RatingDescriptor.create(:title => desc)
    end
  end

  def self.down
  end
end
