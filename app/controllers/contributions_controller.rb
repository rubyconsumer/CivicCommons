class ContributionsController < ApplicationController
  include ContributionsHelper

  def destroy
    @contribution = Contribution.find(params[:id])
    respond_to do |format|
      if @contribution.destroy_by_user(current_person)
        format.js   { render :nothing => true, :status => :ok }
      else
        format.js   { render :json => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end

  def moderate_contribution
    verify_admin
    @contribution = Contribution.find(params[:id])
    @contribution.moderate_contribution
    redirect_to conversation_path(@contribution.conversation)
  end

  def create_confirmed_contribution
    @contribution = Contribution.create_confirmed_node_level_contribution(params[:contribution], current_person)
    redirect_to("#{contribution_parent_page(@contribution)}#contribution#{@contribution.id}",
                    :notice => 'Contribution was successfully created.')
  end
end
