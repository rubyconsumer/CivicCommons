class ActivityObserver < ActiveRecord::Observer

  observe :contribution, :conversation, :issue, :rating_group

end
