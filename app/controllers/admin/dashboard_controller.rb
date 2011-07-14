class Admin::DashboardController < ApplicationController

  before_filter :verify_admin

  layout 'admin'

  def show
  end

end
