class FeaturedOpportunitiesTables < ActiveRecord::Migration
  def self.up
    create_table :featured_opportunities, :force => true do |t|
      t.integer :conversation_id
    end
    create_table :featured_opportunities_contributions, :force => true, :id => false do |t|
      t.integer :featured_opportunity_id
      t.integer :contribution_id
    end
    create_table :featured_opportunities_actions, :force => true, :id => false do |t|
      t.integer :featured_opportunity_id
      t.integer :action_id
    end
    create_table :featured_opportunities_reflections, :force => true, :id => false do |t|
      t.integer :featured_opportunity_id
      t.integer :reflection_id
    end
    
    add_index :featured_opportunities, :conversation_id, :name => :on_conversation_id
    add_index :featured_opportunities_contributions, [:featured_opportunity_id, :contribution_id], :name => :on_featured_opportunity_id_and_contribution_id
    add_index :featured_opportunities_actions, [:featured_opportunity_id, :action_id], :name => :on_featured_opportunity_id_and_action_id
    add_index :featured_opportunities_reflections, [:featured_opportunity_id, :reflection_id], :name => :on_featured_opportunity_id_and_reflection_id
  end

  def self.down
    remove_index :featured_opportunities, :name => :on_conversation_id
    remove_index :featured_opportunities_contributions, :name => :on_featured_opportunity_id_and_contribution_id
    remove_index :featured_opportunities_actions, :name => :on_featured_opportunity_id_and_action_id
    remove_index :featured_opportunities_reflections, :name => :on_featured_opportunity_id_and_reflection_id
    
    drop_table :featured_opportunities_reflections
    drop_table :featured_opportunities_actions
    drop_table :featured_opportunities_contributions
    drop_table :featured_opportunities
  end
end