class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.references :conversable, :polymorphic=>true
      t.references :postable, :polymorphic=>true      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
