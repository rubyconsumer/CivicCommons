class ActivityObserver < ActiveRecord::Observer

  observe :contribution, :conversation, :issue, :rating_group

  def after_create(model)
    unless model.is_a?(Contribution)
      a = Activity.new(model)
      a.save
    end
  end

  def after_save(model)
    if model.is_a?(Contribution)
      if model.confirmed
        if Activity.where(item_id: model.id, item_type: 'Contribution').empty?
          a = Activity.new(model)
          a.save
        end
      end
    end
  end

  def before_destroy(model)
    Activity.destroy(model)
  end

end
