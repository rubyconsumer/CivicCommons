class IssuesController < ApplicationController
  layout 'category_index'
  before_filter :require_user, :only => [:create_contribution]

  # GET /issues
  def index
    @search = Issue.sort(params[:sort]).where(:type => 'Issue').where(:exclude_from_result => false)
    @issues = @search.paginate(:page => params[:page], :per_page => 20)

    @recent_items = Activity.most_recent_activity_items(3)
  end

  # GET /issues/1
  def show
    @issue = Issue.includes(:conversations, :participants).find(params[:id])
    @issue.visit!((current_person.nil? ? nil : current_person.id))

    if @issue.is_a?(ManagedIssue) and @issue.index

      @page = @issue.index
      render 'managed_issue_pages/show'

    else

      @latest_conversations = @issue.conversations.latest_updated.limit(3)
      all_conversations_on_issue = @issue.conversations.latest_updated
      @conversations = all_conversations_on_issue.paginate(:page => params[:page], :per_page => 6)
      @people = @issue.participants.uniq
      @conversation_comments = @issue.conversation_comments.most_recent
      @contributions = @issue.contributions.most_recent
      @recent_items = Activity.most_recent_activity_items_for_issue(@issue, 5)
    end
  end

  def create_contribution
    @issue = Issue.find(params[:id])
    params[:contribution].merge!(:issue_id => @issue.id)
    unless params[:contribution][:url].blank?
      embedly = EmbedlyService.new
      embedly.fetch_and_merge_params!(params)
    end
    @contribution = Contribution.create_node(params[:contribution], current_person, true)
    Subscription.create_unless_exists(current_person, @issue)

    respond_to do |format|
      if @contribution.save
        format.html { render :partial => 'issues/create_contribution', :locals => {:issue => @issue}, :status => :created }
        format.js
      else
        format.html { render :json => {:errors => @contribution.errors.full_messages }, :status => :unprocessable_entity }
        format.js { render :json => {:errors => @contribution.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end

end
