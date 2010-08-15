class Post < ActiveRecord::Base
  belongs_to :conversable, :polymorphic=>true
  belongs_to :postable, :polymorphic=>true
  
  def Post.create_post(params, parent_id, owner, conversable_type, postable_type)  
    entity = postable_type.new(params)        
    entity.errors.add "parent_id", "The parent could not be found." and return entity if parent_id.nil? 
    
    parent = conversable_type.find(parent_id)
    entity.errors.add "parent_id", "The parent could not be found." and return entity if parent.nil? 
    
    entity.person = owner
    
    if entity.save
      parent.posts << Post.new({:postable=>entity, :display_time=>Time.now})
      parent.save
    end
    return entity
  end
end
