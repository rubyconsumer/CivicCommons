class PersonObserver < ActiveRecord::Observer

  def after_save(person)
    AvatarService.update_person(person)
  end

end
