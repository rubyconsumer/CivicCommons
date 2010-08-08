class Post < ActiveRecord::Base
  belongs_to :conversable, :polymorphic=>true
  belongs_to :postable, :polymorphic=>true
end
