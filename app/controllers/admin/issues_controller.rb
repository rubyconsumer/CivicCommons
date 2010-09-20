class Admin::IssuesController < Admin::DashboardController
  
  #GET admin/issues/
  def index
    @issues = Issue.all
  end
  
  #GET admin/issues/new
  def new
    @issue = Issue.new(params[:issue])
  end

  #POST admin/issues
  def create
    @issue = Issue.new(params[:issue])
    if @issue.save
      redirect_to admin_issues_path
      flash[:notice] = "Thank you for submitting an issue"
    else
      render new_issue_path
    end
  end

  #GET admin/issues/:id/edit
  def edit
    @issue = Issue.find(params[:id])
  end
  
  #PUT admin/issues/:id
  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      redirect_to admin_issues_path
      flash[:notice] = "Thank you for updating the issue"
    else
      render admin_edit_issue_path(@issue)
    end
  end

  #GET admin/issues/:id
  def show
    @issue = Issue.find(params[:id])
  end
  
  #DELETE admin/issues/:id
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
  end

end
