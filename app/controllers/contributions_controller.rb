class ContributionsController < ApplicationController
  include ContributionsHelper

  def create_from_pa
    if params.has_key?(:issue_id)
      item = Issue.find(params[:issue_id])
    else
      item = Conversation.find(params[:conversation_id])
      parent = item.contributions.find(params[:parent_contribution_id])
    end

    contribution = Contribution.
      create_confirmed_node_level_contribution({:type => "PplAggContribution",
                                                 :url => params[:link],
                                                 :title => params[:title],
                                                 :item => item,
                                                 :parent => parent},
                                     Person.find(params[:person_id]))
    contribution.save!
    redirect_to polymorphic_url(item)

  end

  def update
    @contribution = Contribution.find(params[:id])

    respond_to do |format|
      if @contribution.update_attributes_by_user(params[:contribution], current_person)
        format.js   { render :status => :ok }
        format.html { redirect_to(@contribution, :notice => 'Contribution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.js   { render :json => @contribution.errors, :status => :unprocessable_entity }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end

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
