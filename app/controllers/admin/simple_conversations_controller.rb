class Admin::SimpleConversationsController < Admin::DashboardController
  # GET /simple_conversations
  # GET /simple_conversations.xml
  def index
    @simple_conversations = SimpleConversation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @simple_conversations }
    end
  end

  # GET /simple_conversations/1
  # GET /simple_conversations/1.xml
  def show
    @simple_conversation = SimpleConversation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @simple_conversation }
    end
  end

  # GET /simple_conversations/new
  # GET /simple_conversations/new.xml
  def new
    @simple_conversation = SimpleConversation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @simple_conversation }
    end
  end

  # GET /simple_conversations/1/edit
  def edit
    @simple_conversation = SimpleConversation.find(params[:id])
  end

  # POST /simple_conversations
  # POST /simple_conversations.xml
  def create
    @simple_conversation = SimpleConversation.new(params[:simple_conversation])

    respond_to do |format|
      if @simple_conversation.save
        format.html { redirect_to(@simple_conversation, :notice => 'Simple conversation was successfully created.') }
        format.xml  { render :xml => @simple_conversation, :status => :created, :location => @simple_conversation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @simple_conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /simple_conversations/1
  # PUT /simple_conversations/1.xml
  def update
    @simple_conversation = SimpleConversation.find(params[:id])

    respond_to do |format|
      if @simple_conversation.update_attributes(params[:simple_conversation])
        format.html { redirect_to(@simple_conversation, :notice => 'Simple conversation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @simple_conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /simple_conversations/1
  # DELETE /simple_conversations/1.xml
  def destroy
    @simple_conversation = SimpleConversation.find(params[:id])
    @simple_conversation.destroy

    respond_to do |format|
      format.html { redirect_to(simple_conversations_url) }
      format.xml  { head :ok }
    end
  end
end
