class ActivityObserver < ActiveRecord::Observer

  observe :contribution, :conversation, :issue, :rating_group

  def after_create(model)
    unless model.is_a?(Contribution)
      a = Activity.new(model)
      a.save
    end
  end

  def before_destroy(model)
    Activity.destroy(model)
  end

end
