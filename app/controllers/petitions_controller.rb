class PetitionsController < ApplicationController
  layout 'opportunity'

  before_filter :require_user, :except => [:show, :print]
  before_filter :verify_admin, :only => [:edit,:update,:destroy]
  before_filter :find_conversation

  def new
    @petition = @conversation.petitions.build
  end

  def show
    @petition = @conversation.petitions.includes(:signatures).includes(:signers).find(params[:id])
    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def edit
    @petition = @conversation.petitions.find(params[:id])
  end

  def update
    @petition = @conversation.petitions.find(params[:id])
    if @petition.update_attributes(params[:petition])
      redirect_to conversation_petition_path(@conversation, @petition)
    else
      render :action => :edit
    end
  end

  def destroy
    @petition = @conversation.petitions.find(params[:id])
    @petition.destroy

    flash[:notice] = 'The petition have been successfully deleted'
    redirect_to conversation_actions_path(@conversation)
  end

  def create
    @petition = @conversation.petitions.build(params[:petition])
    @petition.person_id = current_person.id
    if @petition.save
      @petition.sign(current_person)
      redirect_to conversation_petition_path(@conversation, @petition)
    else
      render :action => :new
    end
  end

  def sign
    @petition = @conversation.petitions.find(params[:id])
    @petition.sign(current_person)
    flash[:petition_notice] = '<strong>Thank you!</strong> You successfully signed this petition.'
    redirect_to conversation_petition_path(@conversation, @petition)
  end

  def sign_modal
    @petition = @conversation.petitions.find(params[:id])
    #returns the sign modal dialog
    render :layout => false
  end

  def print
    @petition = @conversation.petitions.includes(:signatures).includes(:signers).find(params[:id])
    render layout: false
  end

protected
  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
