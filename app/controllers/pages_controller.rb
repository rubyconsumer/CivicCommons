class PagesController < ApplicationController

  def show
    @template = ContentTemplate.find(params[:id])
    render :show
  rescue ActiveRecord::RecordNotFound => e
    redirect_to root_path
  end

end
