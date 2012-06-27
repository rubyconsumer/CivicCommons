class FeaturedOpportunity < ActiveRecord::Base
  belongs_to :conversation
  has_and_belongs_to_many :contributions, :join_table => :featured_opportunities_contributions, :uniq => true
  has_and_belongs_to_many :actions, :join_table => :featured_opportunities_actions, :uniq => true
  has_and_belongs_to_many :reflections, :join_table  => :featured_opportunities_reflections, :uniq => true

  validates_presence_of :conversation_id, :contributions, :reflections, :actions

  def contribution
    self.contributions.first
  end

  def action
    self.actions.first.actionable
  end

  def reflection
    self.reflections.first
  end
end
