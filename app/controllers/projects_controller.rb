class ProjectsController < ApplicationController
  layout 'category_index'

  # GET /projects
  def index
    @projects = Issue.where(:type => 'ManagedIssue').where(:exclude_from_result => false).paginate(:page => params[:page], :per_page => 20)
    @recent_items = Activity.most_recent_activity_items(3)
  end

end
