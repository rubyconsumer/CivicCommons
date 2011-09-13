require 'socket'
class Admin::DashboardController < ApplicationController

  before_filter :verify_admin

  layout 'admin'

  def show
    @host = Socket.gethostname
  end

end
