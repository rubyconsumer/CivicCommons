class IssuesController < ApplicationController
  before_filter :require_user, :only => [:create_contribution]

  # GET /issues
  # GET /issues.xml
  def index
    @search = Issue.sort(params[:sort])
    @issues = @search.paginate(:page => params[:page], :per_page => 20)

    @regions = Region.all
    @main_article = Article.issue_main_article.first
    @sub_articles = Article.issue_sub_articles.limit(3)
    @recent_items = TopItem.newest_items(3).for(:issue).collect(&:item)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @issues }
      format.json  { render :json => @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.xml
  def show
    @issue = Issue.includes(:conversations, :participants).find(params[:id])
    @latest_conversations = @issue.conversations.latest_updated.limit(3)
    all_conversations_on_issue = @issue.conversations.latest_updated
    @conversations = all_conversations_on_issue.paginate(:page => params[:page], :per_page => 6)
    @people = @issue.participants
    @conversation_comments = @issue.conversation_comments.most_recent
    @suggested_actions = @issue.suggested_actions.most_recent
    @media_contributions = @issue.media_contributions.most_recent

    @issue.visit!((current_person.nil? ? nil : current_person.id))
    @recent_items = TopItem.newest_items(3).for(:issue => @issue.id).collect(&:item)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @issue }
      format.json  { render :json => @issue }
    end
  end

  def create_contribution
    @issue = Issue.find(params[:id])
    contribution_params = params[:contribution].merge(:issue_id => @issue.id)
    @contribution = Contribution.
      create_confirmed_node_level_contribution(contribution_params, current_person)
    Subscription.create_unless_exists(current_person, @issue)

    respond_to do |format|
      if @contribution.save
        format.html { render :partial => 'issues/contributions/media_contribution', :locals => {:contribution => @contribution}, :status => :created }
        format.js
      else
        format.html { render :json => {:errors => @contribution.errors.full_messages }, :status => :unprocessable_entity }
        format.js { render :json => {:errors => @contribution.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end

end
