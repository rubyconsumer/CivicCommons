class ManagedIssuePagesController < ApplicationController

  def show
    begin
      @managed_issue_page = ManagedIssuePage.find(params[:id])
      render :show
    rescue ActiveRecord::RecordNotFound => e
      redirect_to issues_path
    end
  end

end
