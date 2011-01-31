class ConversationsController < ApplicationController
  before_filter :require_user, :only=>[:new_node_contribution, :preview_node_contribution, :confirm_node_contribution]

  # GET /conversations
  # GET /conversations.xml
  def index
    @conversations = Conversation.latest_updated.paginate(:page => params[:page], :per_page => 12)

    @main_article = Article.conversation_main_article.first
    @sub_articles = Article.conversation_sub_articles.limit(3)
    @regions = Region.all
    @recent_items = TopItem.newest_items(3).for(:conversation).collect(&:item)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conversations }
    end
  end

  # GET /conversations/1
  # GET /conversations/1.xml
  def show
    @conversation = Conversation.includes(:issues).find(params[:id])
    @conversation.visit!((current_person.nil? ? nil : current_person.id))
    @top_level_contributions = TopLevelContribution.where(:conversation_id => @conversation.id).includes([:person]).order('created_at ASC').with_user_rating(current_person)
    # grab all direct contributions to conversation that aren't TLC
    @conversation_contributions = Contribution.not_top_level.confirmed.without_parent.where(:conversation_id => @conversation.id).includes([:person]).order('created_at ASC').with_user_rating(current_person)
    #@contributions = Contribution.confirmed.with_user_rating(current_person).descendants_of(@conversation_contributions).includes([:person])

    @top_level_contribution = Contribution.new # for conversation comment form
    @tlc_participants = @top_level_contributions.collect{ |tlc| tlc.owner }

    @latest_contribution = @conversation.confirmed_contributions.most_recent.first

    @recent_items = TopItem.newest_items(5).for(:conversation => @conversation.id).collect(&:item)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conversation }
    end
  end

  def node_conversation
    @contribution = Contribution.find(params[:id])
    @contributions = @contribution.children.confirmed.includes(:person)
    @contributions = @contributions.with_user_rating(current_person) if current_person
    @contribution.visit!((current_person.nil? ? nil : current_person.id))

    respond_to do |format|
      format.js { render :partial => "conversations/node_conversation", :layout => false}
      format.html { render :partial => "conversations/node_conversation", :layout => false}
    end
  end

  def node_permalink
    contribution = Contribution.with_user_rating(current_person).find(params[:id])
    @contributions = contribution.self_and_ancestors.with_user_rating(current_person)
    @top_level_contribution = @contributions.root
    contribution.visit!((current_person.nil? ? nil : current_person.id))

    respond_to do |format|
      format.js
    end
  end

  def edit_node_contribution
    @contribution = Contribution.find(params[:contribution_id])
    respond_to do |format|
      format.js{ render(:partial => 'conversations/new_contribution_form', :locals => {:div_id => params[:div_id], :type => @contribution.type.underscore.to_sym}, :layout => false) }
    end
  end

  def update_node_contribution
    @contribution = Contribution.with_user_rating(current_person).find(params[:contribution][:id])
    respond_to do |format|
      if @contribution.update_attributes_by_user(params[:contribution], current_person)
        format.js{ render(:partial => "conversations/contributions/threaded_contribution_template", :locals => {:contribution => @contribution, :div_id => params[:div_id]}, :layout => false, :status => :ok) }
      else
        format.js   { render :json => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new_node_contribution
    @contribution = Contribution.find_or_new_unconfirmed(params, current_person)
    respond_to do |format|
      format.js { render(:partial => "conversations/tabbed_post_box", :locals => {:div_id => params[:div_id], :layout => false}) }
      format.html { render(:partial => "conversations/tabbed_post_box", :locals => {:div_id => params[:div_id], :layout => false}) }
    end
  end

  def preview_node_contribution
    @contribution = Contribution.update_or_create_node_level_contribution(params[:contribution], current_person)
    respond_to do |format|
      if @contribution.valid?
        format.js { render(:partial => "conversations/new_contribution_preview", :locals => {:div_id => params[:div_id], :layout => false}) }
        format.html { render(:partial => "conversations/new_contribution_preview", :locals => {:div_id => params[:div_id], :layout => 'application'}) }
      else
        format.js   { render :json => @contribution.errors, :status => :unprocessable_entity }
        format.html { render :text => @contribution.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def confirm_node_contribution
    @contribution = Contribution.unconfirmed.find_by_id_and_owner(params[:contribution][:id], current_person.id)

    respond_to do |format|
      if @contribution.confirm!
        Subscription.create(person_id: current_person.id, subscribable_type: @contribution.item_class, subscribable_id: @contribution.item_id)
        format.js   { render :partial => "conversations/contributions/threaded_contribution_template", :locals => {:contribution => @contribution}, :status => (params[:preview] ? :accepted : :created) }
        format.html   { render :partial => "conversations/contributions/threaded_contribution_template", :locals => {:contribution => @contribution}, :status => (params[:preview] ? :accepted : :created) }
        format.xml  { render :xml => @contribution, :status => :created, :location => @contribution }
      else
        format.js   { render :json => @contribution.errors, :status => :unprocessable_entity }
        format.html { render :text => @contribution.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end

end
