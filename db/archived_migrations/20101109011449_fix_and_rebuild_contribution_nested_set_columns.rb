class FixAndRebuildContributionNestedSetColumns < ActiveRecord::Migration
  def self.up
    Contribution.all.each do |c|
      c.destroy if c.unconfirmed? || c.invalid?
    end
    Contribution.rebuild!
  end

  def self.down
  end
end
