class ManagedIssuePagesController < ApplicationController

  def show
    begin
      @page = ManagedIssuePage.find(params[:id])
      render :show
    rescue ActiveRecord::RecordNotFound => e
      redirect_to issues_path
    end
  end

end
