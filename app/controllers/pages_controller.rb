class PagesController < ApplicationController

  def show
    begin
      @template = ContentTemplate.find(params[:id])
      render :show
    rescue ActiveRecord::RecordNotFound => e
      redirect_to root_path
    end
  end

end
