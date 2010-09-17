class Admin::IssuesController < Admin::DashboardController
  
  #GET admin/issues/
  def index
    @issues = Issue.all
  end

  def new
  end

  def edit
  end

  def show
  end

end
