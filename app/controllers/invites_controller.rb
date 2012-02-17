class InvitesController < ApplicationController
  before_filter :require_user

  def new
    @invite = Invite.new
    @invite.source_type = params[:source_type]
    @invite.source_id = params[:source_id]
    @invite.user = current_person

    respond_to do |format|
      if request.xhr?
        format.html { render :partial => 'form', :layout => false }
        format.js
      else
        format.html
      end
    end
  end

  def create
    @invite = Invite.new(params[:invite])
    @invite.user = current_person
    
    respond_to do |format|
      if @invite.valid?
        @invite.send_invites
        @notice = "Thank you! You're helping to make Northeast Ohio stronger!"      
        
        format.html{ redirect_to({ :controller => @invite.source_type, :action => :show, :id => @invite.source_id }, :notice => @notice) }
        format.js
      else
        flash[:notice] = @error = "There was a problem with this form: #{@invite.errors.full_messages.to_sentence}"
        
        format.html { render :action => "new" }
        format.js
      end
    end    
  end

end
