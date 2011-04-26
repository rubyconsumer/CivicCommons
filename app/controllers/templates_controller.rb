class TemplatesController < ApplicationController
  def show
    @template = ContentTemplate.find(params[:id])
    #render 'static_pages/about'
  end
end
