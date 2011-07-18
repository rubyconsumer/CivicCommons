class PersonObserver < ActiveRecord::Observer

  def after_save(person)
    AvatarService.update_avatar_url_for(person)
  end

end
