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
    attributes = params[:issue]
    @issue = Issue.new(attributes)
    # manually manage single table inheritance since Rails won't do it automatically
    @issue.type = attributes['type'] if attributes.has_key?('type') and Issue::ALL_TYPES.include?(attributes['type'])
    if @issue.save
      redirect_to admin_issues_path
      flash[:notice] = "Thank you for submitting an issue"
    else
      render :new
    end
  end

  #GET admin/issues/:id/edit
  def edit
    @issue = Issue.find(params[:id])
  end
  
  #PUT admin/issues/:id
  def update
    @issue = Issue.find(params[:id])
    # manually manage single table inheritance since Rails won't do it automatically
    attributes = params[@issue.type.underscore.to_sym]
    @issue.attributes = attributes
    @issue.type = attributes['type'] if attributes.has_key?('type') and Issue::ALL_TYPES.include?(attributes['type'])
    if @issue.save
      redirect_to admin_issues_path
      flash[:notice] = "Thank you for updating the issue"
    else
      render :edit
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
    redirect_to admin_issues_path
  end

end
