class Admin::FeaturedOpportunitiesController < Admin::DashboardController

  def show
    @featured_opportunity = FeaturedOpportunity.find(params[:id])
  end

  def edit
    @featured_opportunity = FeaturedOpportunity.find(params[:id])
    @conversations = Conversation.alphabet_ascending_by_title.all
    build_featured_opportunity_items
  end

  def index
    @featured_opportunities = FeaturedOpportunity.all
  end
  
  def new
    @featured_opportunity = FeaturedOpportunity.new
    @conversations = Conversation.alphabet_ascending_by_title.all
    build_featured_opportunity_items
  end
  
  def create
    @featured_opportunity = FeaturedOpportunity.new(params[:featured_opportunity])
    if @featured_opportunity.save
      redirect_to [:admin,@featured_opportunity]
    else
      @conversations = Conversation.alphabet_ascending_by_title.all  
      build_featured_opportunity_items  
      render :action => :new
    end
  end

  def update
    @featured_opportunity = FeaturedOpportunity.find(params[:id])
    @featured_opportunity.attributes = (params[:featured_opportunity])
    if @featured_opportunity.save
      redirect_to [:admin,@featured_opportunity]
    else
      @conversations = Conversation.alphabet_ascending_by_title.all
      build_featured_opportunity_items
      
      render :action => :edit
    end
  end
  
  def destroy
    @featured_opportunity = FeaturedOpportunity.find(params[:id])
    @featured_opportunity.destroy
    redirect_to :action => :index
  end

  def change_conversation_selection
    @conversation = Conversation.find(params[:conversation_id])
    @contributions = @conversation.contributions
    @actions = @conversation.actions
    @reflections = @conversation.reflections
  end
protected
  def build_featured_opportunity_items
    @featured_opportunity.contributions.build if @featured_opportunity.contributions.length < 1
    @featured_opportunity.actions.build if @featured_opportunity.actions.length < 1
    @featured_opportunity.reflections.build if @featured_opportunity.reflections.length < 1
  end
end
