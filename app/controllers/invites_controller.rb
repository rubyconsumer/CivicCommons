class InvitesController < ApplicationController
  def new
    @source_type = params[:source_type]
    @source_id = params[:source_id]

    respond_to do |format|
      format.html
    end
  end

  def create
    @source_type = params[:source_type]
    @source_id = params[:source_id]

    begin
      redirect_location = url_for(:controller => @source_type, :action=>"show", :id => @source_id)
    rescue Exception
      redirect_location = conversations_url
    end

    if params[:commit] == "Cancel"
      redirect_to redirect_location
    else
      emails = params[:invites][:emails]
      if emails.size > 6 # x@xx.xx
        @conversation = Conversation.find_by_id(@source_id)
        @conversation = Conversation.first unless @conversation
        result = Invite.send_invites(emails, current_person, @conversation)
      else
        result = nil
      end

      respond_to do |format|
        if result
          format.html { redirect_to(redirect_location, :notice => 'Invite was successfully created.') }
          format.xml  { render :xml => @invite, :status => :created, :location => @invite }
        else
          flash[:notice] = "There was a problem with the entered emails."
          format.html { render :action => "new" }
          format.xml  { render :xml => @invite.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

end
