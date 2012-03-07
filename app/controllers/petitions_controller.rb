class PetitionsController < ApplicationController
  layout 'opportunity'
  
  before_filter :require_user, :only => [:new, :create]
  before_filter :find_conversation
  
  def new
    @petition = @conversation.petitions.build
  end

  def show
    @petition = @conversation.petitions.find(params[:id])
  end
  
  def create
    @petition = @conversation.petitions.build(params[:petition])
    @petition.person_id = current_person.id
    if @petition.save
      redirect_to conversation_petition_path(@conversation, @petition)
    else
      render :action => :new
    end
  end
  
protected
  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end