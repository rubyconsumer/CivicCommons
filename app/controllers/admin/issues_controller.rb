class Admin::IssuesController < Admin::DashboardController
  
  #GET admin/issues/
  def index
    @issues = Issue.custom_order
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
    @issue.type = attributes[:type] if attributes.has_key?(:type) and Issue::ALL_TYPES.include?(attributes[:type])
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
    @issue.type = attributes[:type] if attributes.has_key?(:type) and Issue::ALL_TYPES.include?(attributes[:type])
    if @issue.save
      redirect_to admin_issues_path
      flash[:notice] = "Thank you for updating the issue"
    else
      render :edit
    end
  end

  #PUT admin/issues/update_order
  def update_order
    # validate parameters
    current_position = format_param(params[:current])
    next_position = format_param(params[:next])
    previous_position = format_param(params[:prev])
    
    if current_position.nil?
      Issue.assign_positions
      raise "Current position cannot be nil"
    end

    if previous_position.nil?
      set_position(current_position, 0, next_position)
    elsif next_position.nil?
      set_position(current_position, Issue.maximum('position') + 1, previous_position)
    elsif next_position > previous_position
      set_position(current_position, previous_position + 1, next_position)
    elsif next_position < previous_position
      set_position(current_position, next_position + 1, previous_position)
    end

    Issue.assign_positions
    render :nothing => true
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

  private

  def format_param(param)
    if param.match(/^\d+$/)
      param.to_i
    else
      nil
    end
  end

  def set_position(current, new_index, comparison)
    current_issue = Issue.find_by_position(current)
    Issue.where('position >= ?', comparison).each do |issue|
      issue.position += 1
      issue.save
    end
    current_issue.position = new_index
    current_issue.save
  end

end
