class ManagedIssuePagesController < ApplicationController

  def show
    begin
      @issue = ManagedIssue.find(params[:issue_id])
      @page = ManagedIssuePage.find(params[:id])
      render :show
    rescue ActiveRecord::RecordNotFound => e
      if @issue
        redirect_to issue_path(@issue)
      else
        redirect_to issues_path
      end
    end
  end

end
